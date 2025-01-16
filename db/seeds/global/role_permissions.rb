ROLES = %w[ROLE_ADMIN ROLE_CUSTOMER ROLE_PRODUCT_OWNER].freeze

ROLES.each do |role_name|
  Role.find_or_create_by(name: role_name) do |_|
    puts "Seeding role: #{role_name}"
  end
end

USERS_PERMISSIONS = %w[USERS.LIST USERS.CREATE USERS.EDIT USERS.DELETE].freeze
PROFILE_PERMISSIONS = %w[PROFILE.GET PROFILE.EDIT].freeze

ALL_PERMISSIONS = USERS_PERMISSIONS + PROFILE_PERMISSIONS

ALL_PERMISSIONS.each do |permission_name|
  Permission.find_or_create_by(name: permission_name) do |_|
    puts "Seeding Permission: '#{permission_name}'"
  end
end

ROLE_PERMISSIONS = {
  ROLE_ADMIN: ALL_PERMISSIONS,
  ROLE_CUSTOMER: PROFILE_PERMISSIONS,
  ROLE_PRODUCT_OWNER: PROFILE_PERMISSIONS
}

ROLE_PERMISSIONS.each do |role_name, permissions|
  role = Role.find_by(name: role_name)

  # Attach permissions to the role
  permissions.each do |permission_name|
    permission = Permission.find_by(name: permission_name)

    puts "Seeding permission #{permission_name} to role #{role_name}"

    role.permissions << permission unless role.permissions.include?(permission)
  end
end
