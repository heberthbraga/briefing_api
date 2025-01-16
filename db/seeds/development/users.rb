User.find_or_create_by(email: "admin@example.com") do |admin|
  puts "Seeding admin user"

  admin.first_name = "Super"
  admin.last_name = "Admin"
  admin.password = "test1234"
  admin.password_confirmation = "test1234"
  admin.add_role(:ROLE_ADMIN)
end

User.find_or_create_by(email: "customer@example.com") do |customer|
  puts "Seeding customer user"

  customer.first_name = "Customer"
  customer.password = "test1234"
  customer.password_confirmation = "test1234"
  customer.add_role(:ROLE_CUSTOMER)
end

User.find_or_create_by(email: "product-owner@example.com") do |owner|
  puts "Seeding product owner user"

  owner.first_name = "Owner"
  owner.password = "test1234"
  owner.password_confirmation = "test1234"
  owner.add_role(:ROLE_PRODUCT_OWNER)
end
