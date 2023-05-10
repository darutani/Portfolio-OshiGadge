class User < ApplicationRecord
  MAX_USER_NAME_LENGTH = 20

  has_many :gadgets, dependent: :destroy
  has_one_attached :avatar
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true, length: { maximum: MAX_USER_NAME_LENGTH }, uniqueness: { case_sensitive: false }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :lockable, :timeoutable

  # ゲストユーザーの作成
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
      user.avatar.attach(io: File.open('app/assets/images/default_icon_image.png'), filename: 'default_icon_image.png', content_type: 'image/png')
    end
  end

  # ゲストユーザーかどうか判断するメソッド
  def guest?
    email == 'guest@example.com'
  end

  # パスワードなしでユーザーが自分のアカウントを更新できるようにする
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  # 他のユーザーをフォローするメソッド
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # フォローを外すメソッド
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # フォローしているか判定するメソッド
  def following?(other_user)
    followings.include?(other_user)
  end

  # application_helper.rbに移動
  # アイコン画像が未設定の場合にデフォルト画像を設定するメソッド
  # def avatar_image
  #   avatar.attached? ? avatar : "default_icon_image.png"
  # end
end
