class CreateGadgets < ActiveRecord::Migration[6.1]
  def change
    create_table :gadgets do |t|
      t.string :name
      t.date :start_date
      t.string :category
      t.text :reason
      t.text :point
      t.text :usage
      t.text :feature
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
