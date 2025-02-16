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

ActiveRecord::Schema[8.1].define(version: 2025_01_28_210851) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audits1984_audits", force: :cascade do |t|
    t.bigint "auditor_id", null: false
    t.datetime "created_at", null: false
    t.text "notes"
    t.bigint "session_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["auditor_id"], name: "index_audits1984_audits_on_auditor_id"
    t.index ["session_id"], name: "index_audits1984_audits_on_session_id"
  end

  create_table "console1984_commands", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "sensitive_access_id"
    t.bigint "session_id", null: false
    t.text "statements"
    t.datetime "updated_at", null: false
    t.index ["sensitive_access_id"], name: "index_console1984_commands_on_sensitive_access_id"
    t.index ["session_id", "created_at", "sensitive_access_id"], name: "on_session_and_sensitive_chronologically"
  end

  create_table "console1984_sensitive_accesses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "justification"
    t.bigint "session_id", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_console1984_sensitive_accesses_on_session_id"
  end

  create_table "console1984_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "reason"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["created_at"], name: "index_console1984_sessions_on_created_at"
    t.index ["user_id", "created_at"], name: "index_console1984_sessions_on_user_id_and_created_at"
  end

  create_table "console1984_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["username"], name: "index_console1984_users_on_username"
  end

  create_table "database_dumps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "event_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "event_id", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.string "uuid"
    t.index ["event_id"], name: "index_event_requests_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "action"
    t.datetime "created_at", null: false
    t.bigint "creator_id"
    t.json "details", default: {}, null: false
    t.bigint "eventable_id"
    t.string "eventable_type"
    t.bigint "target_id"
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_events_on_creator_id"
    t.index ["eventable_type", "eventable_id"], name: "index_events_on_eventable"
    t.index ["target_id"], name: "index_events_on_target_id"
  end

  create_table "hackathon_digest_listings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "digest_id", null: false
    t.bigint "hackathon_id", null: false
    t.bigint "subscription_id", null: false
    t.datetime "updated_at", null: false
    t.index ["digest_id"], name: "index_hackathon_digest_listings_on_digest_id"
    t.index ["hackathon_id"], name: "index_hackathon_digest_listings_on_hackathon_id"
    t.index ["subscription_id"], name: "index_hackathon_digest_listings_on_subscription_id"
  end

  create_table "hackathon_digests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "recipient_id", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_hackathon_digests_on_created_at"
    t.index ["recipient_id"], name: "index_hackathon_digests_on_recipient_id"
  end

  create_table "hackathon_subscriptions", force: :cascade do |t|
    t.string "airtable_id"
    t.string "city"
    t.string "country_code"
    t.datetime "created_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.string "postal_code"
    t.string "province"
    t.integer "status", default: 1, null: false
    t.bigint "subscriber_id", null: false
    t.datetime "updated_at", null: false
    t.index ["airtable_id"], name: "index_hackathon_subscriptions_on_airtable_id", unique: true
    t.index ["country_code", "city"], name: "index_hackathon_subscriptions_on_country_code_and_city"
    t.index ["country_code", "province", "city"], name: "index_hackathon_subscriptions_on_country_and_province_and_city"
    t.index ["latitude", "longitude"], name: "index_hackathon_subscriptions_on_latitude_and_longitude"
    t.index ["postal_code"], name: "index_hackathon_subscriptions_on_postal_code"
    t.index ["status", "subscriber_id"], name: "index_hackathon_subscriptions_on_status_and_subscriber_id"
    t.index ["subscriber_id"], name: "index_hackathon_subscriptions_on_subscriber_id"
  end

  create_table "hackathon_swag_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "delivered_at", precision: nil
    t.bigint "hackathon_id", null: false
    t.bigint "mailing_address_id", null: false
    t.datetime "updated_at", null: false
    t.index ["hackathon_id"], name: "index_hackathon_swag_requests_on_hackathon_id"
    t.index ["mailing_address_id"], name: "index_hackathon_swag_requests_on_mailing_address_id"
  end

  create_table "hackathons", force: :cascade do |t|
    t.string "address"
    t.string "airtable_id"
    t.boolean "apac"
    t.bigint "applicant_id", null: false
    t.string "city"
    t.string "country_code"
    t.datetime "created_at", null: false
    t.datetime "ends_at", null: false
    t.integer "expected_attendees"
    t.boolean "high_school_led", default: true, null: false
    t.float "latitude"
    t.float "longitude"
    t.integer "modality", default: 0, null: false
    t.string "name", null: false
    t.string "postal_code"
    t.string "province"
    t.datetime "starts_at", null: false
    t.integer "status", default: 0, null: false
    t.string "street"
    t.bigint "swag_mailing_address_id"
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["address"], name: "index_hackathons_on_address"
    t.index ["airtable_id"], name: "index_hackathons_on_airtable_id", unique: true
    t.index ["applicant_id"], name: "index_hackathons_on_applicant_id"
    t.index ["country_code", "city"], name: "index_hackathons_on_country_code_and_city"
    t.index ["country_code", "province", "city"], name: "index_hackathons_on_country_code_and_province_and_city"
    t.index ["latitude", "longitude"], name: "index_hackathons_on_latitude_and_longitude"
    t.index ["postal_code"], name: "index_hackathons_on_postal_code"
    t.index ["status", "starts_at", "ends_at"], name: "index_hackathons_on_status_and_starts_at_and_ends_at"
    t.index ["swag_mailing_address_id"], name: "index_hackathons_on_swag_mailing_address_id"
  end

  create_table "locks", force: :cascade do |t|
    t.integer "capacity", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "expiration"
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.index ["expiration"], name: "index_locks_on_expiration"
    t.index ["key"], name: "index_locks_on_key"
  end

  create_table "mailing_addresses", force: :cascade do |t|
    t.string "city", null: false
    t.string "country_code", default: "US", null: false
    t.datetime "created_at", null: false
    t.string "line1", null: false
    t.string "line2"
    t.string "name"
    t.string "postal_code"
    t.string "province"
    t.datetime "updated_at", null: false
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.string "concurrency_key", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error"
    t.bigint "job_id", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "active_job_id"
    t.text "arguments"
    t.string "class_name", null: false
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at"
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "queue_name", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "hostname"
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.text "metadata"
    t.string "name", null: false
    t.integer "pid", null: false
    t.bigint "supervisor_id"
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "run_at", null: false
    t.string "task_key", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.text "arguments"
    t.string "class_name"
    t.string "command", limit: 2048
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.integer "priority", default: 0
    t.string "queue_name"
    t.string "schedule", null: false
    t.boolean "static", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.integer "value", default: 1, null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "taggings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "tag_id", null: false
    t.bigint "taggable_id", null: false
    t.string "taggable_type", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id", "tag_id"], name: "index_taggings_on_taggable_type_and_taggable_id_and_tag_id", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "color_hex"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name"
  end

  create_table "user_authentications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["token"], name: "index_user_authentications_on_token", unique: true
    t.index ["user_id"], name: "index_user_authentications_on_user_id"
  end

  create_table "user_sessions", force: :cascade do |t|
    t.bigint "authentication_id", null: false
    t.datetime "created_at", null: false
    t.datetime "last_accessed_at", precision: nil
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["authentication_id"], name: "index_user_sessions_on_authentication_id"
    t.index ["token"], name: "index_user_sessions_on_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name"
    t.json "settings", default: {}, null: false
    t.datetime "updated_at", null: false
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "event_requests", "events"
  add_foreign_key "events", "users", column: "creator_id"
  add_foreign_key "events", "users", column: "target_id"
  add_foreign_key "hackathon_digest_listings", "hackathon_digests", column: "digest_id"
  add_foreign_key "hackathon_digest_listings", "hackathon_subscriptions", column: "subscription_id"
  add_foreign_key "hackathon_digest_listings", "hackathons"
  add_foreign_key "hackathon_digests", "users", column: "recipient_id"
  add_foreign_key "hackathon_subscriptions", "users", column: "subscriber_id"
  add_foreign_key "hackathon_swag_requests", "hackathons"
  add_foreign_key "hackathon_swag_requests", "mailing_addresses"
  add_foreign_key "hackathons", "mailing_addresses", column: "swag_mailing_address_id"
  add_foreign_key "hackathons", "users", column: "applicant_id"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "user_authentications", "users"
  add_foreign_key "user_sessions", "user_authentications", column: "authentication_id"
end
