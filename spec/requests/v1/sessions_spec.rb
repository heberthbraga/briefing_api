require "swagger_helper"

RSpec.describe "Sessions API", type: :request do
  path "#{RequestSpecHelper.api_v1_path}/sessions/basic" do
    post "Authenticate user with basic credentials" do
      tags "Sessions"
      consumes RequestSpecHelper.application_json
      produces RequestSpecHelper.application_json
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: "user@example.com" },
          password: { type: :string, example: "password123" }
        },
        required: %w[email password]
      }

      response "200", "Authentication successful" do
        schema type: :object,
               properties: {
                 access_token: { type: :string },
                 refresh_token: { type: :string }
               },
               required: %w[access_token refresh_token]

        let(:password) { Faker::Internet.password(min_length: 8) }
        let!(:user) { create(:user, password: password, password_confirmation: password) }
        let(:credentials) { { email: user.email, password: password } }

        run_test! do |response|
          data = response_to_json(response)

          expect(data[:access_token]).not_to be_nil
          expect(data[:refresh_token]).not_to be_nil
        end
      end

      response "401", "Authentication failed" do
        schema type: :object,
               properties: {
                 code: { type: :string, example: "err.authentication" },
                 detail: { type: :string, example: "Failed to authenticate" },
                 status: { type: :integer, example: 401 },
                 data: {
                   type: :array,
                   items: { type: :object },
                   example: [] # Empty array example
                 }
               },
               required: %w[code detail status data]

        let(:credentials) { { email: "user@example.com", password: "wrong_password" } }
        run_test! do |response|
          data = response_to_json(response)

          expect(data[:detail]).to eq "Failed to authenticate"
        end
      end

      response "422", "Schema Validation Error" do
        schema type: :object,
               properties: {
                 code: { type: :string, example: "err.schema.validation" },
                 detail: { type: :string, example: "Request Schema Validation Error" },
                 status: { type: :integer, example: 422 },
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       field: { type: :string, example: "email" },
                       details: { type: :array, items: { type: :string, example: "Email has an invalid format" } }
                     }
                   }
                 }
               },
               required: %w[code detail status data]

        let(:credentials) { { email: "invalid_email", password: "short" } }

        run_test! do |response|
          data = response_to_json(response)

          expect(data[:detail]).to eq("Request Schema Validation Error")
          expect(data[:data].size).to eq 1
        end
      end
    end
  end
end
