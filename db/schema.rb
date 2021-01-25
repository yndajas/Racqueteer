# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_25_111042) do

  create_table "frame_brands", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
  end

  create_table "frame_models", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
  end

  create_table "match_racquets", force: :cascade do |t|
    t.integer "match_id"
    t.integer "racquet_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "sport_id"
    t.integer "opponent_id"
    t.integer "location_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "score"
    t.string "result"
    t.integer "user_id"
  end

  create_table "opponents", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
  end

  create_table "racquets", force: :cascade do |t|
    t.integer "frame_brand_id"
    t.integer "frame_model_id"
    t.integer "string_brand_id"
    t.integer "string_model_id"
    t.integer "sport_id"
    t.integer "user_id"
  end

  create_table "sports", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
  end

  create_table "string_brands", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
  end

  create_table "string_models", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
  end

end
