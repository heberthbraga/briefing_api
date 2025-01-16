FactoryBot.define do
  factory :permission do
    sequence(:name) { |n| "PERMISSION_#{n}" } # Generates unique permission names if needed

    # For specific permissions, you can use traits
    trait :users_list do
      name { 'USERS.LIST' }
    end

    trait :users_create do
      name { 'USERS.CREATE' }
    end

    trait :users_edit do
      name { 'USERS.EDIT' }
    end

    trait :users_delete do
      name { 'USERS.DELETE' }
    end

    trait :profile_get do
      name { 'PROFILE.GET' }
    end

    trait :profile_edit do
      name { 'PROFILE.EDIT' }
    end
  end
end