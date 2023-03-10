class RemoveUserIdFromGadgets < ActiveRecord::Migration[6.1]
  def change
    remove_column :gadgets, :user_id, :sring
  end
end
