require "rails_helper"

describe V1::Security::AuthenticateWithBasic, type: :service do
  subject(:context) { described_class.call(@email, @password) }

  context "when an user enters valid credentials" do
    before do
      @password = Faker::Internet.password(min_length: 8)

      @user = create(:user, password: @password, password_confirmation: @password)
      @email = @user.email
    end

    it "returns authentication response data" do
      expect(context).to be_success

      auth_data = context.result

      expect(auth_data).not_to be_nil
      user = auth_data[:user]
      expect(user).not_to be_nil
      expect(user.email).to eq user.email

      type = auth_data[:type]
      expect(type).not_to be_nil
      expect(type).to eq "basic"
    end
  end

  context "when an user does not enter valid credentials" do
    before do
      create(:user)
    end

    before do
      @email = "john@example.com"
      @password = "test1234"
    end

    it "returns invalid credentials error" do
      expect(context).to be_failure
      expect(context.result).to be_nil

      errors = context.errors

      expect(errors).not_to be_empty
      invalid_credentials = errors[:invalid_credentials]
      expect(invalid_credentials.first).to eq "Could not authenticate due to invalid credentials"
    end
  end
end
