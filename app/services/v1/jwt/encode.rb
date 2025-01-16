# frozen_string_literal: true

class V1::Jwt::Encode
  prepend SimpleCommand

  def initialize(payload, access = true)
    @payload = payload
    @access = access
  end

  def call
    Rails.logger.info("Starting to encode the JWT token")

    token_expiry = Token::Expiry.new

    payload[:exp] = access ? token_expiry.expire_access : token_expiry.expire_refresh
    payload[:iat] = token_expiry.token_issued_at.to_i
    payload[:jti] = Token::Helper.jti

    JWT.encode(payload, Token::Helper.jwt_secret)
  end

  private

  attr_reader :payload, :access
end
