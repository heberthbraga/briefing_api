class CacheService
  def initialize
    @enabled = ENV.fetch("REDIS_ENABLED") == "true"
    @expires_in = ENV.fetch("REDIS_TTL", 1.hour)
  end

  def fetch(key)
    return yield unless enabled

    Rails.cache.fetch(key, expires_in: expires_in) do
      yield
    end
  rescue Redis::BaseError => e
    Rails.logger.error("Redis error: #{e.message}")
    yield
  end

  def read(key)
    return Rails.cache.read(key) if enabled

    nil
  rescue Redis::BaseError => e
    Rails.logger.error("Redis error on read: #{e.message}")
    nil
  end

  def write(key, value)
    return Rails.cache.write(key, value, expires_in: expires_in) if enabled

    value
  rescue Redis::BaseError => e
    Rails.logger.error("Redis error on write: #{e.message}")
    value
  end

  def delete(key)
    return Rails.cache.delete(key) if enabled

    nil
  rescue Redis::BaseError => e
    Rails.logger.error("Redis error on delete: #{e.message}")
    nil
  end

  private

  attr_reader :enabled, :expires_in
end
