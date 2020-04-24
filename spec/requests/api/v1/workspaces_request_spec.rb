module Api
  module V1
    require "rails_helper"

    RSpec.describe "Workspaces", type: :request do
      describe "index" do
        it "returns only workspaces of which the user is member"
      end

      describe 'show' do
        it "returns the requested workspace"

        it "does not return non-existent workspaces"

        it "does not return the requested workspace if the user is not a member"
      end

      describe "create" do
        it "correctly creates a workspace"

        it "creates a workspaces with conflicting name and description"

        it "does not create a workspace if the name is too short (or missing)"

        it "does not create a workspace if the user is unauthenticated"

        it "does not create a workspace with a client-generated id"
      end

      describe "update" do
        it "correctly updates a workspace"

        it "does not update a workspace if the user is not the supervisor"
      end

      describe "destroy" do
        it "correctly destroys the workspace"

        it "does not destroy the workspace if the user is not the supervisor"
      end
    end
  end
end
