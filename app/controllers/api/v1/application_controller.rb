module Api
  module V1
    class ApplicationController < ActionController::API
      include Api::V1::Concerns::JsonApi
      include DeviseTokenAuth::Concerns::SetUserByToken
    end
  end
end
