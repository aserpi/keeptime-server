class Api::V1::ApplicationSerializer
  include FastJsonapi::ObjectSerializer

  class << self
    delegate :url_helpers, to: :'Rails.application.routes'
  end
end
