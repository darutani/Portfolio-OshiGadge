class Gadget < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  acts_as_taggable_on :categories

  validates :name, presence: true
  validates :point, presence: true

  # いいね済かどうかの判定
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  # 検索対象カラムの設定
  def self.ransackable_attributes(auth_object = nil)
    %w[name reason usage point]
  end

  # 検索対象の関連テーブルの設定
  def self.ransackable_associations(auth_object = nil)
    []
  end
end
