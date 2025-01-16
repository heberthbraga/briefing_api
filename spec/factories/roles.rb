FactoryBot.define do
  factory :role, class: Role do
    sequence(:name) { |n| "ROLE_#{n}" } # Generates unique role names if needed

    transient do
      profile_permissions { [ create(:permission, :profile_get), create(:permission, :profile_edit) ] }
      permissions { [] }
    end

    trait :admin do
      name { "ROLE_ADMIN" }

      after(:create) do |role, evaluator|
        default_permissions = %w[
          USERS.LIST USERS.CREATE USERS.EDIT USERS.DELETE
          PROFILE.GET PROFILE.EDIT
        ]

        permissions_to_add = evaluator.permissions.presence || default_permissions

        role.permissions << permissions_to_add.map { |perm| Permission.find_or_create_by(name: perm) }
      end
    end

    trait :customer do
      name { "ROLE_CUSTOMER" }

      after(:create) do |role, evaluator|
        role.permissions << evaluator.profile_permissions
      end
    end

    trait :product_owner do
      name { "ROLE_PRODUCT_OWNER" }

      after(:create) do |role, evaluator|
        role.permissions << evaluator.profile_permissions
      end
    end
  end
end
