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

ActiveRecord::Schema[7.0].define(version: 2023_07_20_000103) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "event_requests", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "uuid"
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_requests_on_event_id"
  end

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
    t.string "street"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "website", null: false
    t.boolean "high_school_led", default: true, null: false
    t.integer "expected_attendees", null: false
    t.integer "modality", default: 0, null: false
    t.boolean "financial_assistance", null: false
    t.bigint "applicant_id", null: false
    t.bigint "swag_mailing_address_id"
    t.index ["address"], name: "index_hackathons_on_address"
    t.index ["applicant_id"], name: "index_hackathons_on_applicant_id"
    t.index ["country_code", "city"], name: "index_hackathons_on_country_code_and_city"
    t.index ["country_code", "province", "city"], name: "index_hackathons_on_country_code_and_province_and_city"
    t.index ["latitude", "longitude"], name: "index_hackathons_on_latitude_and_longitude"
    t.index ["postal_code"], name: "index_hackathons_on_postal_code"
    t.index ["status", "starts_at", "ends_at"], name: "index_hackathons_on_status_and_starts_at_and_ends_at"
    t.index ["swag_mailing_address_id"], name: "index_hackathons_on_swag_mailing_address_id"
  end

  create_table "mailing_addresses", force: :cascade do |t|
    t.string "name"
    t.string "line1", null: false
    t.string "line2"
    t.string "city", null: false
    t.string "province"
    t.string "postal_code"
    t.string "country_code", default: "US", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.string "taggable_type", null: false
    t.bigint "taggable_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id", "tag_id"], name: "index_taggings_on_taggable_type_and_taggable_id_and_tag_id", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.string "color_hex"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name"
  end

  create_table "user_authentications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_user_authentications_on_token"
    t.index ["user_id"], name: "index_user_authentications_on_user_id"
  end

  create_table "user_sessions", force: :cascade do |t|
    t.bigint "authentication_id", null: false
    t.string "token", null: false
    t.datetime "last_accessed_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authentication_id"], name: "index_user_sessions_on_authentication_id"
    t.index ["token"], name: "index_user_sessions_on_token"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "event_requests", "events"
  add_foreign_key "events", "users", column: "creator_id"
  add_foreign_key "events", "users", column: "target_id"
  add_foreign_key "hackathons", "mailing_addresses", column: "swag_mailing_address_id"
  add_foreign_key "hackathons", "users", column: "applicant_id"
  add_foreign_key "user_authentications", "users"
  add_foreign_key "user_sessions", "user_authentications", column: "authentication_id"
end
