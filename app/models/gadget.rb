class Gadget < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true
  validates :category, presence: true
  validates :point, presence: true

  # いいね済かどうかの判定
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end
