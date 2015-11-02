class Initialize < ActiveRecord::Migration
  def change
    
    #-------------------------- User --------------------------
    create_table :users do |t|
      t.string   :name, unique: true, null: false
      t.string   :slug, unique: true, null: false
      t.string   :crypted_password,   null: false
      t.string   :password_salt,      null: false
      t.string   :persistence_token,  null: false
      
      t.string   :avatar
      t.text     :about
      t.string   :email
      t.string   :locale
      
      t.string   :role
      t.integer  :lvl
      t.integer  :exp
      t.integer  :moral

      t.integer  :login_count, default: 0, null: false
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.string   :last_login_ip
      t.string   :current_login_ip      
    end
    add_index :users, :name
    add_index :users, :slug
    add_index :users, :persistence_token
    add_index :users, :last_request_at  
    
    create_table :followings do |t|
      t.integer :followee_id
      t.integer :follower_id
      t.timestamps
    end
    add_index :followings, [:followee_id, :follower_id]
    add_index :followings, [:follower_id, :followee_id]
    
    create_table :user_votes do |t|
      t.integer :user_id
      t.integer :votable_id
      t.string  :votable_type
      t.integer :rating
      t.timestamps
    end
    add_index :user_votes, :user_id
    add_index :user_votes, :votable_id
    
    create_table :invites do |t|
      t.integer :user_id
      t.string :word
      t.integer :used_by
      t.timestamps
    end    
    add_index :invites, :user_id
    add_index :invites, :used_by
    
    create_table :notes do |t|
      t.integer :user_id
      t.integer :polish_id
      t.text    :body
      t.timestamps
    end
    add_index :notes, :user_id   

    create_table :box_items do |t|
      t.integer  :polish_id
      t.integer  :box_id
      t.integer  :use_count, default: 0
      t.integer  :ordering
      t.timestamps
    end
    add_index :box_items, [:box_id, :polish_id], name: "index_box_items_on_box_id_and_polish_id"
    
    create_table :boxes do |t|
      t.integer  :user_id
      t.string   :name
      t.string   :slug
      t.text     :import_result
      t.integer  :box_items_count, default: 0
      t.string   :spreadsheet
      t.timestamps
    end
    add_index :boxes, :user_id

    #------------------------- Polish --------------------
    create_table :polishes do |t|
      t.integer :collection_id
      t.integer :bottle_id
      t.string  :name
      t.string  :slug, null: false
      t.string  :number
      t.integer :release_year
      t.string  :brand_name, null: false
      t.string  :brand_slug, null: false
      
      t.integer :user_id, null: false
      t.integer :brand_id, null: false
      t.integer :comments_count, default: 0
      t.integer :usages_count,   default: 0
      t.integer :coats_count,    default: 0
      t.integer :layers_count,   default: 0
      t.integer :votes_count,    default: 0
      t.decimal :rating, precision: 5, scale: 4, default: 0.0000

      t.boolean :draft, default: false      
      t.boolean :bottling_status, default: false      
      t.integer :h
      t.integer :s
      t.integer :l
      t.integer :h2
      t.integer :s2
      t.integer :l2
      t.integer :opacity
      t.string  :magnet
      t.string  :gloss_type
      t.string  :gloss_colour
      t.string  :mask_type
      t.boolean :lock
      t.string  :reference
      t.timestamps
    end
    add_index :polishes, :collection_id
    add_index :polishes, :user_id
    add_index :polishes, :brand_id
    add_index :polishes, :bottle_id
    add_index :polishes, :h
    add_index :polishes, :s
    add_index :polishes, :l
    add_index :polishes, :h2
    add_index :polishes, :s2
    add_index :polishes, :l2
    add_index :polishes, :gloss_type
    add_index :polishes, :opacity
    add_index :polishes, :mask_type
    add_index :polishes, :slug
    add_index :polishes, :release_year

    create_table :polish_versions do |t|
      t.integer :polish_id
      t.integer :user_id
      t.string  :user_name
      t.string  :user_avatar_url
      t.string  :event
      t.text    :polish
      t.integer :version
      t.timestamps
    end
    add_index :polish_versions, :polish_id
    add_index :polish_versions, :user_id
    
    create_table :polish_layers do |t|
      t.integer :polish_id, null: false
      t.integer :ordering, default: 0 
      t.string  :layer_type

      t.string  :c_base
      t.string  :c_duo
      t.string  :c_multi
      t.string  :c_cold
      t.integer :opacity

      t.string  :highlight_colour
      t.string  :shadow_colour

      t.integer :holo_intensity,   default: 0
      t.integer :magnet_intensity, default: 0
      
      t.string  :particle_type
      t.integer :particle_size
      t.integer :particle_density
      t.integer :thickness, default: 50
      
      t.timestamps
    end
    add_index :polish_layers, :polish_id
    add_index :polish_layers, :particle_type
    add_index :polish_layers, :holo_intensity
    
    create_table :brands do |t|
      t.string  :name, unique: true, null: false
      t.string  :slug, unique: true, null: false
      t.string  :link
      t.integer :user_id, null: false
      t.integer :polishes_count, default: 0
      t.integer :drafts_count, default: 0
      t.integer :unbottled_count, default: 0
      t.timestamps
    end
    add_index :brands, :name, unique: true
    add_index :brands, :slug, unique: true
    
    create_table :collections do |t|
      t.integer :brand_id
      t.string  :name
      t.timestamps
    end
    add_index :collections, :brand_id
    add_index :collections, :name

    create_table :synonyms do |t|
      t.string  :word_type
      t.integer :word_id
      t.string  :name
      t.timestamps
    end
    add_index :synonyms, :word_type
    add_index :synonyms, :word_id
    add_index :synonyms, :name    
    
    create_table :bottles do |t|
      t.integer :user_id, null: false
      t.integer :brand_id, null: false
      
      t.string  :name
      t.string  :brand_slug, null: false
      t.json    :layers
      t.integer :blur, default: 0
      t.timestamps
    end
    add_index :bottles, :brand_id
    #------------------------- Diary ----------------------
    
    create_table :entries do |t|
      t.integer :user_id
      t.integer :finger_count, default: 1
      t.string  :title
      t.text    :body
      t.string  :nail_look
      t.date    :applied_at
      t.integer :duration, default: 0
      t.integer :nail_shape
      t.integer :nail_length
      t.string  :colour
      t.string  :gloss
      t.string  :lock
      t.integer :rating,         default: 0
      t.integer :comments_count, default: 0
      t.integer :views_count,    default: 0
      t.integer :swatches_count, default: 0
      t.timestamps
    end
    add_index :entries, :user_id
    add_index :entries, :title
    add_index :entries, :colour
    
    create_table :usages do |t|
      t.integer :entry_id
      t.integer :polish_id
      t.integer :ordering, default: 0
      t.integer :coats, default: 1
      t.integer :finger
      t.timestamps
    end
    add_index :usages, [:entry_id, :polish_id]    
    
    create_table :comments do |t|
      t.integer :user_id
      t.string  :user_name
      t.string  :user_slug
      t.integer :votes_count
      t.integer :commentable_id
      t.string  :commentable_type
      t.text    :body
      t.integer :rating, default: 0
      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, [:commentable_id, :commentable_type]

    create_table :swatches do |t|
      t.integer :entry_id
      t.string  :swatch
      t.float   :aspect_ratio
      t.timestamps
    end
    add_index :swatches, :entry_id
    
    create_table :tags do |t|
      t.string :name
      t.timestamps
    end
    add_index :tags, :name
    
    create_table :taggings do |t|
      t.belongs_to :tag
      t.belongs_to :entry

      t.timestamps
    end
    add_index :taggings, :tag_id
    add_index :taggings, :entry_id
  end
end
