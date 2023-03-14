class DropProfiles < ActiveRecord::Migration[6.1]
  def change
    drop_table :profiles do |t|
      t.string :name
      t.text :introduction
      t.bigint :user_id

      t.timestamps
    end
  end
end
