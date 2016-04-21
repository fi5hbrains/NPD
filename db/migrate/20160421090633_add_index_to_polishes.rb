class AddIndexToPolishes < ActiveRecord::Migration
  def change
    add_index :polishes, :number
  end
end
