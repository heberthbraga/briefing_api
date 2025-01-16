module V1
  module Sessions
    class CreateBasicParamsSchema < ApplicationContract
      params do
        required(:email).filled(:string, format?: URI::MailTo::EMAIL_REGEXP)
        required(:password).filled(:string)
      end
    end
  end
end
