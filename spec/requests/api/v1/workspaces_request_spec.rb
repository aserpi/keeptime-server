module Api
  module V1
    require "rails_helper"

    RSpec.describe "Workspaces", type: :request do
      describe "index" do
        it "returns only workspaces of which the user is member" do
          workspace = FactoryBot.create :workspace
          FactoryBot.create :second_workspace
          get api_v1_workspaces_path, headers: auth_headers

          expect(response).to have_http_status(:ok)
          expect(document).to have_link(:first).with_value("/api/v1/workspaces?page=1").and(
              have_link(:prev).with_value(nil)).and(
              have_link(:next).with_value(nil)).and(
              have_link(:last).with_value("/api/v1/workspaces?page=1"))

          expect(document["data"].size).to eq(1)
          expect_workspace(document["data"][0], workspace)
        end
      end

      describe 'show' do
        it "returns the requested workspace" do
          workspace = FactoryBot.create :workspace
          get api_v1_workspace_path(workspace), headers: auth_headers

          expect(response).to have_http_status(:ok)
          expect_workspace document["data"], workspace
        end

        it "does not return non-existent workspaces" do
          get api_v1_workspace_path(0), headers: auth_headers
          expect(response).to have_http_status(:forbidden)
        end

        it "does not return the requested workspace if the user is not a member" do
          workspace = FactoryBot.create(:second_workspace)
          get api_v1_workspace_path(workspace), headers: auth_headers
          expect(response).to have_http_status(:forbidden)
        end
      end

      describe "create" do
        def workspace_params
          workspace = FactoryBot.build :workspace
          { data: { type: :workspaces, attributes: { description: workspace.description, name: workspace.name } } }
        end

        it "correctly creates a workspace" do
          post api_v1_workspaces_path, headers: auth_headers, params: workspace_params
          workspace = Workspace.first

          expect(response).to have_http_status(:created)
          expect_workspace(document["data"], workspace)
        end

        it "creates a workspaces with conflicting name and description" do
          FactoryBot.create :workspace
          post api_v1_workspaces_path, headers: auth_headers, params: workspace_params
          workspace = Workspace.second

          expect(response).to have_http_status(:created)
          expect_workspace(document["data"], workspace)
        end

        it "does not create a workspace if the name is too short (or missing)" do
          params = workspace_params
          params[:data][:attributes][:name] = nil

          post api_v1_workspaces_path, headers: auth_headers, params: params
          expect(response).to have_http_status(:bad_request)
        end

        it "does not create a workspace if the user is unauthenticated" do
          post api_v1_workspaces_path, params: workspace_params
          expect(response).to have_http_status(:forbidden)
        end

        it "does not create a workspace with a client-generated id" do
          params = workspace_params
          params[:data][:id] = "5"

          post api_v1_workspaces_path, headers: auth_headers, params: params
          expect(response).to have_http_status(:forbidden)
        end

        it "does not create a workspace with a relationship" do
          params = workspace_params
          params[:data][:relationships] = { supervisor: :test }

          post api_v1_workspaces_path, headers: auth_headers, params: params
          expect(response).to have_http_status(:forbidden)
          expect(document["errors"][0]["code"]).to eq("forbidden_relationship")
        end

        it "does not create a workspace with a wrong resource type" do
          params = workspace_params
          params[:data][:type] = :test

          post api_v1_workspaces_path, headers: auth_headers, params: params
          expect(response).to have_http_status(:conflict)
          expect(document["errors"][0]["code"]).to eq("wrong_type")
        end
      end

      describe "update" do
        it "correctly updates a workspace" do
          workspace = FactoryBot.create(:workspace)
          params = update_params workspace

          workspace.name = params[:data][:attributes][:name]
          patch api_v1_workspace_path(workspace), headers: auth_headers, params: params

          expect(response).to have_http_status(:ok)
          expect_workspace(document["data"], workspace)
        end

        it "does not update a workspace if the id is wrong" do
          workspace = FactoryBot.create(:workspace)
          params = update_params workspace
          params[:data][:id] = "wrong_id"

          patch api_v1_workspace_path(workspace), headers: auth_headers, params: params
          expect(response).to have_http_status(:conflict)
          expect(document["errors"][0]["code"]).to eq("wrong_id")
        end

        it "does not update a workspace if the resource type is wrong" do
          workspace = FactoryBot.create(:workspace)
          params = update_params workspace
          params[:data][:type] = :wrong_type

          patch api_v1_workspace_path(workspace), headers: auth_headers, params: params
          expect(response).to have_http_status(:conflict)
          expect(document["errors"][0]["code"]).to eq("wrong_type")
        end

        it "does not update a workspace if the user is not the supervisor" do
          workspace = FactoryBot.create :second_workspace
          params = update_params workspace

          patch api_v1_workspace_path(workspace), headers: auth_headers, params: params
          expect(response).to have_http_status(:forbidden)
        end
      end

      describe "destroy" do
        it "correctly destroys the workspace" do
          workspace = FactoryBot.create(:workspace)
          delete api_v1_workspace_path(workspace), headers: auth_headers
          expect(response).to have_http_status(:no_content)
        end

        it "does not destroy the workspace if the user is not the supervisor" do
          workspace = FactoryBot.create(:second_workspace)
          delete api_v1_workspace_path(workspace), headers: auth_headers
          expect(response).to have_http_status(:forbidden)
        end
      end

      def auth_headers
        @current_user = RegisteredUser.find_by(username: "username") || FactoryBot.create(:registered_user)
        @current_user.create_new_auth_token
      end

      def document
        JSON.parse(response.body)
      end

      def expect_workspace(data, workspace)
        expect(data).to have_type("workspaces")
        expect(data).to have_link(:self).with_value(api_v1_workspace_path workspace)

        expect(data).to have_jsonapi_attributes(:description, :name).exactly
        expect(data).to have_attribute(:description).with_value(workspace.description)
        expect(data).to have_attribute(:name).with_value(workspace.name)

        expect(data).to have_relationships("placeholder_users", "registered_users", "supervisor")
        expect(data["relationships"]["placeholder_users"]).to(
            have_link(:self).with_value(relationships_placeholder_users_api_v1_workspace_path workspace).and(
                have_link(:related).with_value(placeholder_users_api_v1_workspace_path workspace)))
        expect(data["relationships"]["registered_users"]).to(
            have_link(:self).with_value(relationships_registered_users_api_v1_workspace_path workspace).and(
                have_link(:related).with_value(registered_users_api_v1_workspace_path workspace)))
        expect(data["relationships"]["supervisor"]).to(
            have_link(:related).with_value(api_v1_registered_user_path workspace.supervisor.id))
        expect(data["relationships"]["supervisor"]["data"]).to(
            have_type("registered_users").and(
                have_id(workspace.supervisor.id.to_s)))
      end

      def update_params(workspace)
        { data: { attributes: { name: "updatedName" }, id: workspace.id.to_s, type: :workspaces } }
      end
    end
  end
end
