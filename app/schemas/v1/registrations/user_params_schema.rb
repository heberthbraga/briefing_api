module V1
  module Registrations
    class UserParamsSchema < ApplicationContract
      ALLOWED_TYPES = %w[CUSTOMER PRODUCT_OWNER].freeze

      params do
        required(:email).filled(:string, format?: URI::MailTo::EMAIL_REGEXP)
        required(:first_name).filled(:string)
        optional(:last_name).value(:string)
        required(:password).filled(:string, min_size?: 8)
        required(:password_confirmation).filled(:string)
        required(:account_type).filled(:string, included_in?: ALLOWED_TYPES)
      end

      rule(:password_confirmation) do
        key.failure("does not match password") if values[:password] != value
      end
    end
  end
end
