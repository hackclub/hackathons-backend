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

ActiveRecord::Schema[7.0].define(version: 2023_07_17_112942) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "eventable_type"
    t.bigint "eventable_id"
    t.bigint "creator_id"
    t.bigint "target_id"
    t.string "action"
    t.jsonb "details", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_events_on_creator_id"
    t.index ["eventable_type", "eventable_id"], name: "index_events_on_eventable"
    t.index ["target_id"], name: "index_events_on_target_id"
  end

  create_table "hackathons", force: :cascade do |t|
    t.string "name", null: false
    t.integer "status", default: 0, null: false
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.string "country_code"
    t.string "province"
    t.string "city"
    t.string "postal_code"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.index ["address"], name: "index_hackathons_on_address"
    t.index ["country_code", "city"], name: "index_hackathons_on_country_code_and_city"
    t.index ["country_code", "province", "city"], name: "index_hackathons_on_country_code_and_province_and_city"
    t.index ["latitude", "longitude"], name: "index_hackathons_on_latitude_and_longitude"
    t.index ["postal_code"], name: "index_hackathons_on_postal_code"
    t.index ["status", "starts_at", "ends_at"], name: "index_hackathons_on_status_and_starts_at_and_ends_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "name"
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "events", "users", column: "creator_id"
  add_foreign_key "events", "users", column: "target_id"
end
