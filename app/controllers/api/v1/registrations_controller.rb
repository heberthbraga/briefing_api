# frozen_string_literal: true

class Api::V1::RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: :create

  def create
    Rails.logger.info("Signing up the User")

    new_registration = V1::Registrations::Create.call(create_permitted_params).result

    if new_registration[:has_errors]
      raise Errors::Validation.new(new_registration[:record])
    end

    render json: new_registration, status: :created
  end

  private

  def default_schema
    V1::Registrations::UserParamsSchema
  end

  def create_permitted_params
    params.permit(:email, :first_name, :last_name, :password, :password_confirmation, :account_type)
  end
end
