FactoryBot.define do
  factory :gadget do
    user
    name { Faker::Device.model_name }
    category_list { Faker::Commerce.department(max: 1) }
    point { Faker::Lorem.sentence }

    # gadgetに画像を添付する
    after(:create) do |gadget|
      image_path = Rails.root.join('spec', 'support', 'assets', 'test_gadget_image.jpg')
      gadget.image.attach(io: File.open(image_path), filename: 'test_gadget_image.jpg', content_type: 'image/jpeg')
    end
  end
end

