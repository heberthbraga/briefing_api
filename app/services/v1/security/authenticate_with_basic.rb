class V1::Security::AuthenticateWithBasic
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    Rails.logger.debug("Authenticating user with email=#{email}")

    user = User.authenticate(email.downcase, password)

    return { user: user, type: "basic" } if user

    errors.add(:invalid_credentials, "Could not authenticate due to invalid credentials")
    nil
  end

  private

  attr_reader :email, :password
end
