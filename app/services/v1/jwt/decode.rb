# frozen_string_literal: true

class V1::Jwt::Decode
  prepend SimpleCommand

  def initialize(token)
    @token = token
  end

  def call
    Rails.logger.info("Starting to decode the JWT token")

    decoded_token = JWT.decode(token, Token::Helper.jwt_secret)

    decoded_token ? (HashWithIndifferentAccess.new decoded_token[0]) : nil
  rescue JWT::DecodeError, JWT::VerificationError => e
    Rails.logger.error "JWT Decode error = #{e.inspect}"
    nil
  end

  private

  attr_reader :token
end
