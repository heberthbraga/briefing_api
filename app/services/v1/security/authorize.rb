# frozen_string_literal: true

class V1::Security::Authorize
  prepend SimpleCommand

  def initialize(headers)
    @token = headers["Authorization"]&.split("Bearer ")&.last
  end

  def call
    Rails.logger.info("Starting to authorize the user")

    decoded_token = decode

    return unless decoded_token

    masked_user_id = decoded_token[:sub]

    @user = User.find_by_masked_id(masked_user_id)

    @user || errors.add(:unauthorized, "Could not authorize the user")
  end

  private

  attr_reader :token

  def decode
    return V1::Jwt::Decode.call(token).result if token.present?

    errors.add(:invalid_token, "The token is invalid")

    nil
  end
end
