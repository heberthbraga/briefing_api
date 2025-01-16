class User < ApplicationRecord
  rolify
  authenticates_with_sorcery!

  has_and_belongs_to_many :roles

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: { case_sensitive: true }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true

  def masked_id
    HashidsRails.encode(id)
  end

  def admin?
    has_role?(:ROLE_ADMIN)
  end

  def customer?
    has_role?(:ROLE_CUSTOMER)
  end

  def owner?
    has_role?(:ROLE_PRODUCT_OWNER)
  end

  def permissions
    roles.includes(:permissions).map(&:permissions).flatten.map(&:name).uniq
  end

  # Overriding add_role to make sure we're only associating the role to the user
  def add_role(role_name)
    role = Role.find_by(name: role_name)
    if role
      self.roles << role unless self.roles.include?(role)
    else
      errors.add(:roles, "Role #{role_name} does not exist.")
    end
  end

  def self.find_by_masked_id(masked_id)
    decoded_id = HashidsRails.decode(masked_id).first
    find(decoded_id) if decoded_id
  end
end
