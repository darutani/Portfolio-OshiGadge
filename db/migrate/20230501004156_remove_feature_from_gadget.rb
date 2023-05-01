class RemoveFeatureFromGadget < ActiveRecord::Migration[6.1]
  def change
    remove_column :gadgets, :feature, :text
  end
end
