class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def can?(permission)
    user.permissions.include?(permission)
  end
end
