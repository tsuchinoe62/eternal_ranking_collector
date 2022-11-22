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

ActiveRecord::Schema[7.0].define(version: 2022_11_22_150434) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "guild_histories", force: :cascade do |t|
    t.string "master", null: false
    t.integer "score", null: false
    t.integer "member", null: false
    t.date "stored_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "guild_id", null: false
  end

  create_table "guilds", force: :cascade do |t|
    t.string "name", null: false
    t.string "server", null: false
    t.string "master", null: false
    t.integer "score", null: false
    t.integer "point", null: false
    t.integer "member_count", null: false
    t.integer "guild_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_histories", force: :cascade do |t|
    t.integer "guild_id"
    t.integer "score", null: false
    t.integer "level", null: false
    t.integer "talent_id", null: false
    t.date "stored_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "player_id"
    t.index ["player_id"], name: "index_player_histories_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name", null: false
    t.string "server", null: false
    t.string "job", null: false
    t.integer "guild_id"
    t.integer "score", null: false
    t.integer "level", null: false
    t.integer "talent_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "talents", force: :cascade do |t|
    t.string "name", null: false
    t.integer "talent_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "player_histories", "players"
end
