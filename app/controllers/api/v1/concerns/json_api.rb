module Api
  module V1
    module Concerns
      module JsonApi
        extend ActiveSupport::Concern

        def status_s(status_s)
          Rack::Utils.status_code(status_s).to_s
        end
      end
    end
  end
end
