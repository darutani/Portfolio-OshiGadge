require 'faker'

# Userのダミーデータ作成
20.times do
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: 'password', # 仮のパスワードを入力
    name: Faker::Name.name,
    introduction: Faker::Lorem.paragraph(sentence_count: 2)
  )

  # ActiveStorageで画像を添付
  user.avatar.attach(io: File.open('app/assets/images/default_icon_image.png'), filename: 'default_icon_image.png', content_type: 'image/png')
end

# Gadgetのダミーデータ作成
20.times do
  gadget = Gadget.create!(
    name: Faker::Device.model_name,
    start_date: Faker::Date.between(from: 10.years.ago, to: Date.today),
    category: Faker::Commerce.department(max: 1),
    reason: Faker::Lorem.paragraph(sentence_count: 2),
    point: Faker::Lorem.paragraph(sentence_count: 2),
    usage: Faker::Lorem.paragraph(sentence_count: 2),
    feature: Faker::Lorem.paragraph(sentence_count: 2),
    user_id: User.all.sample.id # ランダムなユーザーIDを入力
  )

  # ActiveStorageで画像を添付
  gadget.image.attach(io: File.open('app/assets/images/default_gadget_image.jpg'), filename: 'default_gadget_image.jpg', content_type: 'image/jpg')
end
