class AddVolumeToBottles < ActiveRecord::Migration
  def change
    add_column :bottles, :volume, :integer, default: 10
  end
end
