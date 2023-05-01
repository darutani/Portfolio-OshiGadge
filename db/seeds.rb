require 'faker'

# Userのダミーデータ作成
20.times do
  # 改行を含む２or３行の文を作成し、変数introductionに代入
  introduction = "#{Faker::Lorem.sentence}\n#{Faker::Lorem.sentence}"
  introduction += "\n#{Faker::Lorem.sentence}" if rand(2) == 1

  user = User.create!(
    email: Faker::Internet.unique.email,
    password: 'password', # 仮のパスワードを入力
    name: Faker::Name.name,
    introduction: introduction,
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
    reason: Faker::Lorem.sentences(number: 3).join("\n"),
    point: Faker::Lorem.sentences(number: 3).join("\n"),
    usage: Faker::Lorem.sentences(number: 3).join("\n"),
    user_id: User.all.sample.id # ランダムなユーザーIDを入力
  )

  # ActiveStorageで画像を添付
  gadget.image.attach(io: File.open('app/assets/images/sample_gadget_image.jpg'), filename: 'sample_gadget_image.jpg', content_type: 'image/jpg
  ')
end
