class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :name
      t.string :image
      t.string :image_hover
      t.string :link
      t.string :subtitle
      t.boolean :omni, default: true
      t.int4range :h0, default: (0..360)
      t.int4range :s0, default: (0..100)
      t.int4range :l0, default: (0..100)
      t.int4range :o0, default: (0..100)
      t.int4range :h1, default: (361..362)
      t.int4range :s1, default: (101..102)
      t.int4range :l1, default: (101..102)
      t.int4range :o1, default: (101..102)
      t.int4range :h2, default: (361..362)

      t.timestamps null: false
    end
    add_index :ads, :name
  end
end
