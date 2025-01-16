require "swagger_helper"

RSpec.describe "Users API", type: :request do
  before do
    create_list(:user, 3)
  end

  path "#{RequestSpecHelper.api_v1_path}/users" do
    get "Retrieve a list of users" do
      tags "Users"
      produces RequestSpecHelper.application_json
      security [ Bearer: {} ]
      parameter name: :Authorization, in: :header, type: :string

      response "200", "Users list retrieved successfully" do
        include_context("admin_authentication")

        let(:Authorization) { "Bearer #{@access_token}" }

        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :string, example: "NQlmGnqR" },
                   email: { type: :string },
                   first_name: { type: :string },
                   last_name: { type: :string, nullable: true },
                   roles: {
                     type: :array,
                     items: {
                       type: :object,
                       properties: {
                         id: { type: :string, example: "1" },
                         name: { type: :string, example: "ROLE_CUSTOMER" }
                       }
                     }
                   }
                 }
               }

        run_test! do |response|
          data = response_to_json(response)

          expect(data).to be_an(Array)
          expect(data.size).to be >= 4
        end
      end

      response "403", "Authorization failed when the token is not provided" do
        let(:Authorization) { "Bearer " }

        schema type: :object,
               properties: {
                 code: { type: :string, example: "err.forbidden" },
                 detail: { type: :string, example: "You are not authorized to access this resource." },
                 status: { type: :integer, example: 403 },
                 data: {
                   type: :array,
                   items: { type: :object },
                   example: []
                 }
               },
               required: %w[code detail status data]

        run_test! do |response|
          data = response_to_json(response)

          expect(data[:detail]).to eq("You are not authorized to access this resource.")
        end
      end

      response "403", "Authorization failed when user does not have privileges" do
        include_context("customer_authentication")

        let(:Authorization) { "Bearer #{@access_token}" }

        schema type: :object,
               properties: {
                 code: { type: :string, example: "err.forbidden" },
                 detail: { type: :string, example: "You are not authorized to access this resource." },
                 status: { type: :integer, example: 403 },
                 data: {
                   type: :array,
                   items: { type: :object },
                   example: []
                 }
               },
               required: %w[code detail status data]

        run_test! do |response|
          data = response_to_json(response)

          expect(data[:detail]).to eq("You are not authorized to access this resource.")
        end
      end
    end
  end
end
