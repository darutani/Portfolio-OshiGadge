class RenameUserIdIdColumnToProfiles < ActiveRecord::Migration[6.1]
  def change
    rename_column :profiles, :user_id_id, :user_id
  end
end
