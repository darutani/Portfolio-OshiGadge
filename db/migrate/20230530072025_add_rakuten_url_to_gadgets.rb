class AddRakutenUrlToGadgets < ActiveRecord::Migration[6.1]
  def change
    add_column :gadgets, :rakuten_url, :string
  end
end
