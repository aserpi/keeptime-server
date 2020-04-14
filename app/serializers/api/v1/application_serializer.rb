module Api
  module V1
    class ApplicationSerializer < ActiveModel::Serializer
      include Rails.application.routes.url_helpers
    end
  end
end
