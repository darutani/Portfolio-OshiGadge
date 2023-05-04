FactoryBot.define do
  factory :gadget do
    user
    name { Faker::Device.name }
    category { Faker::Commerce.department(max: 1) }
    point { Faker::Lorem.sentence }
  end
end
