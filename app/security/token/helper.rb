# frozen_string_literal: true

class Token::Helper
  class << self
    def jti
      SecureRandom.hex
    end

    def jwt_secret
      ENV.fetch("JWT_SECRET_KEY")
    end
  end
end
