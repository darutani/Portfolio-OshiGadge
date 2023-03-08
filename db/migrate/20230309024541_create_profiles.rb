class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.references :user_id
      t.string :name
      t.text :introduction
      t.string :icon_image

      t.timestamps
    end
  end
end
