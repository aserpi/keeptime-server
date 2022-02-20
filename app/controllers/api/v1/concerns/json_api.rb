module Api
  module V1
    module Concerns
      module JsonApi
        extend ActiveSupport::Concern

        included do
          rescue_from ActionController::ParameterMissing, with: :missing_parameter
        end

        def check_client_generated_id
          if params.require(:data).has_key?(:id)
            render json: { errors: [{ code: :client_generated_id, source: "/data/id", status: status_s(:forbidden) }] },
                   status: :forbidden
            return false
          end

          true
        end

        def check_forbidden_relationships(*forbidden_rels)
          return true unless params.require(:data).has_key?(:relationships)
          incl_relationships = params.require(:data).permit(relationships: {})[:relationships].keys
          forbidden_rels = forbidden_rels.map &:to_s  # Input is an array of strings

          errors = []
          incl_relationships.select { |incl_rel| forbidden_rels.include?(incl_rel) }.each do |incl_rel|
            errors << { code: :relationship_replacement,
                        source: "/data/relationships/#{incl_rel}",
                        status: status_s(:forbidden) }
          end

          return true if errors.empty?
          render json: { errors: errors }, status: :forbidden
          false
        end

        def check_type(type, params, prefix="")
          if params.require(:data).permit(:type)[:type] != type.to_s
            render json: { errors: [{ code: :wrong_type,
                                      source: "#{prefix}/data/type",
                                      status: status_s(:conflict) }] }, status: :conflict
            return false
          end

          true
        end

        def check_update_id(resource)
          if params.require(:data).require(:id) != resource.id.to_s
            render json: { errors: [{ code: :wrong_id, source: "/data/id", status: status_s(:conflict) }] },
                   status: :conflict
            return false
          end

          true
        end

        def relation_update_ids(required_type)
          records = params.require(:data)
          unless records.is_a? Array
            render json: { errors: [{ code: :array_required, source: "/data" }] }, status: :bad_request
            return
          end

          errors = []
          ids = []
          required_type = required_type.to_s
          records.each_with_index do |record, i|
            if record[:type] != required_type
              errors << { code: :wrong_type, source: "/data/#{i}" }
            else
              begin
                ids << Integer(record[:id])
              rescue ArgumentError
                errors << { code: :wrong_id, source: "/data/#{i}" }
              end
            end
          end

          unless errors.empty?
            render json: { errors: errors }, status: :bad_request
            return ids
          end

          false
        end

        def render_error(resource)
          errors = []
          resource.errors.details.each do |attr, attr_errors|
            attr_errors.each { |error| errors << { code: error[:error], pointer: "/data/attributes/#{attr}" } }
          end
          render json: { errors: errors }, status: :bad_request
        end

        def status_s(status_s)
          Rack::Utils.status_code(status_s).to_s
        end

        private

        def missing_parameter(exception)
          if exception.param == :data
            pointer = "/data"
          elsif exception.param == :attributes
            pointer = "/data/attributes"
          else
            pointer = "/data/attributes/#{exception.param}"
          end
          render json: { errors: [{ code: :missing_parameter, source: pointer }] }, status: :bad_request
        end
      end
    end
  end
end
