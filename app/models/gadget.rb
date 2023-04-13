class Gadget < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :likes, dependent: :destroy

  validates :name, presence: true
  validates :category, presence: true
  validates :point, presence: true

end
