# frozen_string_literal: true

class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: :create_basic

  SCHEMAS = {
    create_basic: V1::Sessions::CreateBasicParamsSchema
  }

  def create_basic
    Rails.logger.info("Creating basic authentication")

    email = create_basic_permitted_params[:email]
    password = create_basic_permitted_params[:password]

    basic_auth = V1::Security::AuthenticateWithBasic.call(email, password)
    tokens = V1::Security::GenerateToken.call(basic_auth).result

    if tokens.present?
      render json: tokens
    else
      raise Errors::Authentication
    end
  end

  def refresh
    p "Refresh user token"
  end

  private

  def create_basic_permitted_params
    params.permit(:email, :password)
  end
end
