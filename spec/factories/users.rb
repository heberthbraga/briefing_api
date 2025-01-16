FactoryBot.define do
  factory :user, class: User do
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    email                 { Faker::Internet.email }
    password              { Faker::Internet.password(min_length: 8) }
    password_confirmation { password }

    trait :admin do
      after(:create) { |user| user.add_role(:ROLE_ADMIN) }
    end

    trait :customer do
      after(:create) { |user| user.add_role(:ROLE_CUSTOMER) }
    end

    trait :owner do
      after(:create) { |user| user.add_role(:ROLE_PRODUCT_OWNER) }
    end
  end
end
