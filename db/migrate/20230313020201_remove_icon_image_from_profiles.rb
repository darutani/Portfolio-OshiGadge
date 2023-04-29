class RemoveIconImageFromProfiles < ActiveRecord::Migration[6.1]
  def change
    remove_column :profiles, :icon_image, :string
  end
end
