class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :gadget

  validates :content, presence: true, length: { minimum: 1, maximum: 400 }
  validates :user_id, presence: true
  validates :gadget_id, presence: true
end
