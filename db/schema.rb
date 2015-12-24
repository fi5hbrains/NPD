# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151223141253) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bottles", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.integer  "brand_id",               null: false
    t.string   "name"
    t.string   "brand_slug",             null: false
    t.json     "layers"
    t.integer  "blur",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bottles", ["brand_id"], name: "index_bottles_on_brand_id", using: :btree

  create_table "box_items", force: :cascade do |t|
    t.integer  "polish_id"
    t.integer  "box_id"
    t.integer  "use_count",  default: 0
    t.integer  "ordering"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "box_items", ["box_id", "polish_id"], name: "index_box_items_on_box_id_and_polish_id", using: :btree

  create_table "boxes", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "slug"
    t.text     "import_result"
    t.integer  "box_items_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "boxes", ["user_id"], name: "index_boxes_on_user_id", using: :btree

  create_table "brands", force: :cascade do |t|
    t.string   "name",                        null: false
    t.string   "slug",                        null: false
    t.string   "link"
    t.integer  "user_id",                     null: false
    t.integer  "polishes_count",  default: 0
    t.integer  "drafts_count",    default: 0
    t.integer  "unbottled_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "brands", ["name"], name: "index_brands_on_name", unique: true, using: :btree
  add_index "brands", ["slug"], name: "index_brands_on_slug", unique: true, using: :btree

  create_table "collections", force: :cascade do |t|
    t.integer  "brand_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collections", ["brand_id"], name: "index_collections_on_brand_id", using: :btree
  add_index "collections", ["name"], name: "index_collections_on_name", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "user_name"
    t.string   "user_slug"
    t.integer  "votes_count"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "body"
    t.integer  "rating",           default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",       default: 0, null: false
    t.integer  "attempts",       default: 0, null: false
    t.text     "handler",                    null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "layer_ordering"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  add_index "delayed_jobs", ["queue"], name: "index_delayed_jobs_on_queue", using: :btree

  create_table "entries", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "finger_count",   default: 1
    t.string   "title"
    t.text     "body"
    t.string   "nail_look"
    t.date     "applied_at"
    t.integer  "duration",       default: 0
    t.integer  "nail_shape"
    t.integer  "nail_length"
    t.string   "colour"
    t.string   "gloss"
    t.string   "lock"
    t.integer  "rating",         default: 0
    t.integer  "comments_count", default: 0
    t.integer  "views_count",    default: 0
    t.integer  "swatches_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entries", ["colour"], name: "index_entries_on_colour", using: :btree
  add_index "entries", ["title"], name: "index_entries_on_title", using: :btree
  add_index "entries", ["user_id"], name: "index_entries_on_user_id", using: :btree

  create_table "followings", force: :cascade do |t|
    t.integer  "followee_id"
    t.integer  "follower_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "followings", ["followee_id", "follower_id"], name: "index_followings_on_followee_id_and_follower_id", using: :btree
  add_index "followings", ["follower_id", "followee_id"], name: "index_followings_on_follower_id_and_followee_id", using: :btree

  create_table "invites", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "word"
    t.integer  "used_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invites", ["used_by"], name: "index_invites_on_used_by", using: :btree
  add_index "invites", ["user_id"], name: "index_invites_on_user_id", using: :btree

  create_table "notes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "polish_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "polish_layers", force: :cascade do |t|
    t.integer  "polish_id",                     null: false
    t.integer  "ordering",         default: 0
    t.string   "layer_type"
    t.string   "c_base"
    t.string   "c_duo"
    t.string   "c_multi"
    t.string   "c_cold"
    t.integer  "opacity"
    t.string   "highlight_colour"
    t.string   "shadow_colour"
    t.integer  "holo_intensity",   default: 0
    t.integer  "magnet_intensity", default: 0
    t.string   "particle_type"
    t.integer  "particle_size"
    t.integer  "particle_density"
    t.integer  "thickness",        default: 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "polish_layers", ["holo_intensity"], name: "index_polish_layers_on_holo_intensity", using: :btree
  add_index "polish_layers", ["particle_type"], name: "index_polish_layers_on_particle_type", using: :btree
  add_index "polish_layers", ["polish_id"], name: "index_polish_layers_on_polish_id", using: :btree

  create_table "polish_versions", force: :cascade do |t|
    t.integer  "polish_id"
    t.integer  "user_id"
    t.string   "user_name"
    t.string   "user_avatar_url"
    t.string   "event"
    t.text     "polish"
    t.integer  "version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "polish_versions", ["polish_id"], name: "index_polish_versions_on_polish_id", using: :btree
  add_index "polish_versions", ["user_id"], name: "index_polish_versions_on_user_id", using: :btree

  create_table "polishes", force: :cascade do |t|
    t.integer  "collection_id"
    t.integer  "bottle_id"
    t.string   "name"
    t.string   "slug",                                                    null: false
    t.string   "number"
    t.integer  "release_year"
    t.string   "brand_name",                                              null: false
    t.string   "brand_slug",                                              null: false
    t.integer  "user_id",                                                 null: false
    t.integer  "brand_id",                                                null: false
    t.integer  "comments_count",                          default: 0
    t.integer  "usages_count",                            default: 0
    t.integer  "coats_count",                             default: 0
    t.integer  "layers_count",                            default: 0
    t.integer  "votes_count",                             default: 0
    t.decimal  "rating",          precision: 5, scale: 4, default: 0.0
    t.boolean  "draft",                                   default: false
    t.boolean  "bottling_status",                         default: false
    t.integer  "h"
    t.integer  "s"
    t.integer  "l"
    t.integer  "h2"
    t.integer  "s2"
    t.integer  "l2"
    t.integer  "opacity"
    t.string   "magnet"
    t.string   "gloss_type"
    t.string   "gloss_colour"
    t.string   "mask_type"
    t.boolean  "lock"
    t.string   "reference"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "prefix"
  end

  add_index "polishes", ["bottle_id"], name: "index_polishes_on_bottle_id", using: :btree
  add_index "polishes", ["brand_id"], name: "index_polishes_on_brand_id", using: :btree
  add_index "polishes", ["collection_id"], name: "index_polishes_on_collection_id", using: :btree
  add_index "polishes", ["gloss_type"], name: "index_polishes_on_gloss_type", using: :btree
  add_index "polishes", ["h"], name: "index_polishes_on_h", using: :btree
  add_index "polishes", ["h2"], name: "index_polishes_on_h2", using: :btree
  add_index "polishes", ["l"], name: "index_polishes_on_l", using: :btree
  add_index "polishes", ["l2"], name: "index_polishes_on_l2", using: :btree
  add_index "polishes", ["mask_type"], name: "index_polishes_on_mask_type", using: :btree
  add_index "polishes", ["opacity"], name: "index_polishes_on_opacity", using: :btree
  add_index "polishes", ["release_year"], name: "index_polishes_on_release_year", using: :btree
  add_index "polishes", ["s"], name: "index_polishes_on_s", using: :btree
  add_index "polishes", ["s2"], name: "index_polishes_on_s2", using: :btree
  add_index "polishes", ["slug"], name: "index_polishes_on_slug", using: :btree
  add_index "polishes", ["user_id"], name: "index_polishes_on_user_id", using: :btree

  create_table "swatches", force: :cascade do |t|
    t.integer  "entry_id"
    t.string   "swatch"
    t.float    "aspect_ratio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "swatches", ["entry_id"], name: "index_swatches_on_entry_id", using: :btree

  create_table "synonyms", force: :cascade do |t|
    t.string   "word_type"
    t.integer  "word_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "synonyms", ["name"], name: "index_synonyms_on_name", using: :btree
  add_index "synonyms", ["word_id"], name: "index_synonyms_on_word_id", using: :btree
  add_index "synonyms", ["word_type"], name: "index_synonyms_on_word_type", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["entry_id"], name: "index_taggings_on_entry_id", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree

  create_table "usages", force: :cascade do |t|
    t.integer  "entry_id"
    t.integer  "polish_id"
    t.integer  "ordering",   default: 0
    t.integer  "coats",      default: 1
    t.integer  "finger"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "usages", ["entry_id", "polish_id"], name: "index_usages_on_entry_id_and_polish_id", using: :btree

  create_table "user_votes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_votes", ["user_id"], name: "index_user_votes_on_user_id", using: :btree
  add_index "user_votes", ["votable_id"], name: "index_user_votes_on_votable_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                          null: false
    t.string   "slug",                          null: false
    t.string   "crypted_password",              null: false
    t.string   "password_salt",                 null: false
    t.string   "persistence_token",             null: false
    t.string   "avatar"
    t.text     "about"
    t.string   "email"
    t.string   "locale"
    t.string   "role"
    t.integer  "lvl"
    t.integer  "exp"
    t.integer  "moral"
    t.integer  "login_count",       default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.integer  "follower_count",    default: 0
    t.integer  "followee_count",    default: 0
  end

  add_index "users", ["last_request_at"], name: "index_users_on_last_request_at", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["persistence_token"], name: "index_users_on_persistence_token", using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree

end
