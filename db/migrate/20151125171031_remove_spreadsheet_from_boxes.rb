class RemoveSpreadsheetFromBoxes < ActiveRecord::Migration
  def change
    remove_column :boxes, :spreadsheet
  end
end
