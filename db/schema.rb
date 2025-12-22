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

ActiveRecord::Schema[8.1].define(version: 2025_12_23_001755) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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

  create_table "aos_pxies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_aos_pxies_on_name"
  end

  create_table "flie_os", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "width", default: 0, null: false
  end

  create_table "os_cmd_gets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "os_cmd_id", null: false
    t.integer "os_get_id", null: false
    t.integer "step"
    t.datetime "updated_at", null: false
    t.index ["os_cmd_id"], name: "index_os_cmd_gets_on_os_cmd_id"
    t.index ["os_get_id"], name: "index_os_cmd_gets_on_os_get_id"
  end

  create_table "os_cmds", force: :cascade do |t|
    t.integer "access", default: 0
    t.datetime "created_at", null: false
    t.string "description", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "os_dos", force: :cascade do |t|
    t.integer "aos_pxy_id", null: false
    t.datetime "created_at", null: false
    t.boolean "doing", default: false
    t.integer "flie_o_id", null: false
    t.string "input"
    t.integer "os_cmd_id", null: false
    t.integer "os_get_id", null: false
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.index ["aos_pxy_id"], name: "index_os_dos_on_aos_pxy_id"
    t.index ["flie_o_id"], name: "index_os_dos_on_flie_o_id"
    t.index ["os_cmd_id"], name: "index_os_dos_on_os_cmd_id"
    t.index ["os_get_id"], name: "index_os_dos_on_os_get_id"
  end

  create_table "os_gets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "input_type", default: 0
    t.string "name"
    t.string "prompt"
    t.datetime "updated_at", null: false
  end

  create_table "os_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "flie_o_id", null: false
    t.string "in"
    t.datetime "updated_at", null: false
    t.index ["flie_o_id"], name: "index_os_logs_on_flie_o_id"
  end

  create_table "pxy_excepts", force: :cascade do |t|
    t.integer "aos_pxy_id", null: false
    t.string "cmd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["aos_pxy_id"], name: "index_pxy_excepts_on_aos_pxy_id"
    t.index ["user_id"], name: "index_pxy_excepts_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tbufs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "flie_o_id", null: false
    t.string "real_path"
    t.integer "status", default: 0
    t.string "ted_path"
    t.datetime "updated_at", null: false
    t.index ["flie_o_id"], name: "index_tbufs_on_flie_o_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.string "verification_token"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["verification_token"], name: "index_users_on_verification_token"
  end

  create_table "yous", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "flie_o_id", null: false
    t.string "home"
    t.string "pwd", default: "/", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["flie_o_id"], name: "index_yous_on_flie_o_id"
    t.index ["pwd"], name: "index_yous_on_pwd"
    t.index ["user_id"], name: "index_yous_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "os_cmd_gets", "os_cmds"
  add_foreign_key "os_cmd_gets", "os_gets"
  add_foreign_key "os_dos", "aos_pxies"
  add_foreign_key "os_dos", "flie_os"
  add_foreign_key "os_dos", "os_cmds"
  add_foreign_key "os_dos", "os_gets"
  add_foreign_key "os_logs", "flie_os"
  add_foreign_key "pxy_excepts", "aos_pxies"
  add_foreign_key "pxy_excepts", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "yous", "flie_os"
  add_foreign_key "yous", "users"
end
