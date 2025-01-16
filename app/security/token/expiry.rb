# frozen_string_literal: true

class Token::Expiry

  def initialize
  end

  def expire_access
    (token_issued_at + access_time).to_i
  end

  def expire_refresh
    (token_issued_at + refresh_time).to_i
  end

  def token_issued_at
    Time.zone.now
  end

  private

  def access_time
    ENV.fetch("ACCESS_TOKEN_EXPIRATION", 20.minutes)
  end

  def refresh_time
    ENV.fetch("REFRESH_TOKEN_EXPIRATION", 5.hours)
  end
end
