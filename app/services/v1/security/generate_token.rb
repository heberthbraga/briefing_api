# frozen_string_literal: true

class V1::Security::GenerateToken
  prepend SimpleCommand

  def initialize(authentication_method)
    @authentication_method = authentication_method
  end

  def call
    authenticator = authentication_method

    return unless authenticator.success?

    payload = authenticator.result
    user = payload[:user]
    type = payload[:type]

    Rails.logger.info("Authenticating##{type} user #{user.id}")

    jwt_body = {
      sub: user.masked_id,
      type: type,
      roles: user.roles.map { |role| role.name }
    }

    {
      access_token: encode(jwt_body, true),
      refresh_token: encode(jwt_body, false)
    }
  end

  private

  attr_reader :authentication_method

  def encode(payload, access)
    V1::Jwt::Encode.call(payload, access).result
  end
end
