class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id, null: false, index: true
      t.integer :source_id
      t.string :author
      t.string :event_type
      t.text :body
      t.boolean :new, default: true
      t.timestamps null: false
    end
  end
end
