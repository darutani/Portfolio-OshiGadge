class Like < ApplicationRecord
  belongs_to :user
  belongs_to :gadget

  validates_uniqueness_of :gadget_id, scope: :user_id
end
