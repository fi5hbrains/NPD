class AddPrefixToPolish < ActiveRecord::Migration
  def change
    add_column :polishes, :prefix, :string
  end
end
