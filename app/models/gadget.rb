class Gadget < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :name, presence: true
  validates :category, presence: true
  validates :point, presence: true

end
