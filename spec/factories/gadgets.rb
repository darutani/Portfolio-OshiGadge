FactoryBot.define do
  factory :gadget do
    user
    sequence(:name) { |n| ('a'.ord + (n - 1) % 26).chr + "_ガジェット" }
    category_list { Faker::Commerce.department(max: 3) }
    point { Faker::Lorem.sentence }
    sequence(:created_at) { |n| Time.current - n.hours }

    # gadgetにlikeを紐づける
    transient do
      likes_count { 0 }
    end

    after(:create) do |gadget, evaluator|
      evaluator.likes_count.times do
        create(:like, gadget: gadget, user: create(:user))
      end
    end

    # gadgetに画像を添付する
    after(:create) do |gadget|
      image_path = Rails.root.join('spec', 'support', 'assets', 'test_gadget_image.jpg')
      gadget.image.attach(io: File.open(image_path), filename: 'test_gadget_image.jpg', content_type: 'image/jpeg')
    end
  end
end
