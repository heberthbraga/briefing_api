class UserPolicy < ApplicationPolicy
  def index?
    can?("USERS.LIST")
  end
end
