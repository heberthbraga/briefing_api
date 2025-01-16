class V1::Registrations::Create
  prepend SimpleCommand

  ALLOWED_TYPES = {
    "CUSTOMER" => :ROLE_CUSTOMER,
    "PRODUCT_OWNER" => :ROLE_PRODUCT_OWNER
  }.freeze

  def initialize(payload)
    @payload = payload
  end

  def call
    account_type = payload[:account_type]
    sanitized_payload = payload.except(:password, :password_confirmation)

    Rails.logger.info("Creating user with #{sanitized_payload.inspect}")

    user = User.new(payload.except(:account_type))
    user.add_role(ALLOWED_TYPES[account_type])

    return { has_errors: true, record: user } unless user.save

    CACHE_SERVICE.delete(CacheKeys::LIST_USERS_KEY)

    UserSerializer.new(user).to_h
  end

  private

  attr_reader :payload
end
