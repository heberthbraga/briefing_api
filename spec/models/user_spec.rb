require "rails_helper"

describe User, type: :model do
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:email) }
  it { should validate_length_of(:password) }
  it { should validate_presence_of(:password_confirmation) }

  context "is admin user" do
    before do
      create(:role, :admin, permissions: %w[USERS.LIST])
      admin = create(:user, :admin)
      admin.add_role(:ROLE_ADMIN)
    end

    it "should has valid props" do
      user = User.first

      expect(user.admin?).to be true
      expect(user.permissions.include?("USERS.LIST")).to be true
    end
  end

  context "is customer user" do
    before do
      create(:role, :customer)
      customer = create(:user, :customer)
      customer.add_role(:ROLE_CUSTOMER)
    end

    it "should has valid props" do
      user = User.first

      expect(user.customer?).to be true
      expect(user.permissions.include?("PROFILE.GET")).to be true
    end
  end

  context "is owner user" do
    before do
      create(:role, :product_owner)
      product_owner = create(:user, :owner)
      product_owner.add_role(:ROLE_PRODUCT_OWNER)
    end

    it "should has valid props" do
      user = User.first

      expect(user.owner?).to be true
      expect(user.permissions.include?("PROFILE.GET")).to be true
    end
  end
end
