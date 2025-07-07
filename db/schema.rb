# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_07_002221) do
  create_table "league_users", force: :cascade do |t|
    t.integer "league_id", null: false
    t.string "user_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id", "user_name"], name: "index_league_users_on_league_id_and_user_name", unique: true
    t.index ["league_id"], name: "index_league_users_on_league_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.string "name"
    t.integer "max_users"
    t.integer "max_picks_per_user"
    t.string "join_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "draft_started", default: false
    t.text "draft_order"
    t.integer "current_pick_position", default: 1
  end

  create_table "picks", force: :cascade do |t|
    t.string "user_name"
    t.integer "league_id"
    t.integer "team_id", null: false
    t.string "pick_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_picks_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.integer "wins"
    t.integer "losses"
    t.decimal "over_under_line"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "league_users", "leagues"
  add_foreign_key "picks", "teams"
end
