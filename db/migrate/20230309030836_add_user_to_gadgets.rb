class AddUserToGadgets < ActiveRecord::Migration[6.1]
  def change
    add_reference :gadgets, :user, null: false, foreign_key: true
  end
end
