require "rails_helper"

describe Role, type: :model do
  it { should validate_presence_of(:name) }
end
