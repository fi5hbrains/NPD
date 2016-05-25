class Tmp < ActiveRecord::Migration
  def change
    drop_table :events
    
    create_table :events do |t|
      t.integer :user_id, null: false, index: true
      t.integer :eventable_id
      t.string :eventable_type
      t.string :author
      t.string :event_type
      t.text :body
      t.boolean :new, default: true
      t.timestamps null: false
    end
    add_index :events, [:eventable_id, :eventable_type]
  end
end
