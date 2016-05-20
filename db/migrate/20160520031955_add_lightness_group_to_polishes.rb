class AddLightnessGroupToPolishes < ActiveRecord::Migration
  def change
    add_column :polishes, :lightness_group, :integer, index: true
  end
end
