require "rails_helper"

describe Permission, type: :model do
  it { should validate_presence_of(:name) }
end
