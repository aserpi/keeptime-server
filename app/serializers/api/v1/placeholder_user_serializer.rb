module Api
  module V1
    class PlaceholderUserSerializer < ApplicationSerializer
      attributes :name

      # TODO: attribute :email, if: <user is workspace supervisor>
    end
  end
end
