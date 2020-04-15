module Api
  module V1
    require 'rails_helper'

    RSpec.describe "Whether access is ocurring properly", type: :request do
      before(:each) do
        @current_user = FactoryBot.create(:registered_user)
      end

      it "correctly authenticates registered users" do
        post api_v1_registered_user_session_path,
             params: { email: @current_user.email, password: @current_user.password,
                       headers: { 'content-type' => 'application/json', accept: 'application/json' } }
        expect_current_user
      end

      it "does not authenticate users with invalid credentials" do
        post api_v1_registered_user_session_path,
             params: { email: @current_user.email, password: "invalidPassword",
                       headers: { 'content-type' => 'application/json', accept: 'application/json' } }
        expect_bad_credentials
      end

      it "correctly validates authentication tokens" do
        token = generate_token
        get api_v1_auth_validate_token_path,
            params: { "access-token" => token.token, client: token.client, uid: @current_user.uid }
        expect_current_user
      end

      it "does not validate non-existent authentication tokens" do
        get api_v1_auth_validate_token_path,
            params: { "access-token" => :invalid_token, client: :invalid_client, uid: @current_user.uid }
        expect_bad_credentials
      end

      it "does not validate expired tokens" do
        token = generate_token
        allow(Time).to receive(:now).and_return(Time.now + DeviseTokenAuth.token_lifespan.seconds)
        get api_v1_auth_validate_token_path,
            params: { "access-token" => token.token, client: token.client, uid: @current_user.uid }
        expect_bad_credentials
      end

      private

      def expect_auth_headers_to(be_status)
        expect(response.has_header?("access-token")).to be_status
        expect(response.has_header?("client")).to be_status
        expect(response.has_header?("expiry")).to be_status
        expect(response.has_header?("uid")).to be_status
      end

      def expect_bad_credentials
        expect(response).to have_http_status(:unauthorized)
        expect_auth_headers_to(be_falsey)

        errors = JSON.parse(response.body)["errors"]
        expect(errors).to be_truthy
        expect(errors.size).to eq(1)
        expect(errors[0]).to eq({ "code" => "bad_credentials", "status" => "401" })
      end

      def expect_current_user
        expect(response).to have_http_status(:ok)
        expect_auth_headers_to(be_truthy)

        serializer = RegisteredUserSerializer.new(@current_user)
        adapter = ActiveModelSerializers::Adapter.create(serializer)
        expect(response.body).to eq(adapter.to_json)
      end

      def generate_token
        token = DeviseTokenAuth::TokenFactory.create
        @current_user.tokens[token.client] = { token:  token.token_hash, expiry: token.expiry }
        @current_user.save!
        return token
      end
    end
  end
end
