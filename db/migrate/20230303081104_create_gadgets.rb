class CreateGadgets < ActiveRecord::Migration[6.1]
  def change
    create_table :gadgets do |t|
      t.integer :user_id
      t.string :name
      t.date :start_date
      t.string :category
      t.text :reason
      t.text :point
      t.text :usage
      t.text :feature

      t.timestamps
    end
  end
end
