FactoryBot.define do
  factory :user do
    sequence(:name) { Faker::Name.name }
    sequence(:email) { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
