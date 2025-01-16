require "swagger_helper"

RSpec.describe "Registrations API", type: :request do
  path '/api/v1/registrations' do
    post 'Create a new user registration' do
      tags 'Registrations'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, format: :email },
          first_name: { type: :string },
          last_name: { type: :string, nullable: true },
          password: { type: :string, minLength: 8 },
          password_confirmation: { type: :string },
          account_type: { type: :string, enum: %w[CUSTOMER PRODUCT_OWNER] }
        },
        required: %w[email first_name password password_confirmation account_type]
      }

      response '201', 'User created successfully' do
        let(:user) do
          {
            email: 'test@example.com',
            first_name: 'John',
            last_name: 'Doe',
            password: 'password123',
            password_confirmation: 'password123',
            account_type: 'CUSTOMER'
          }
        end

        schema type: :object,
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

        run_test!
      end

      response '422', 'Validation errors' do
        let(:user) do
          {
            email: 'invalid_email',
            first_name: '',
            password: 'short',
            password_confirmation: 'short',
            account_type: 'INVALID_TYPE'
          }
        end

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
                       details: {
                         type: :array,
                         items: { type: :string, example: "Email has an invalid format" }
                       }
                     }
                   }
                 }
               },
               required: %w[code detail status data]

        run_test!
      end
    end
  end
end
