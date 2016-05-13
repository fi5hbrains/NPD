class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :polishes, :mask_type, :crackle_type
  end
end
