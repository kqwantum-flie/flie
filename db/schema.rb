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

ActiveRecord::Schema[8.1].define(version: 2025_12_13_220916) do
  create_table "aos_pxies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_aos_pxies_on_name"
  end

  create_table "flie_os", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "out"
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

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "yous", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "flie_o_id", null: false
    t.string "pwd", default: "/", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["flie_o_id"], name: "index_yous_on_flie_o_id"
    t.index ["pwd"], name: "index_yous_on_pwd"
    t.index ["user_id"], name: "index_yous_on_user_id"
  end

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> dc2acd4 (add os_dos)
  add_foreign_key "os_cmd_gets", "os_cmds"
  add_foreign_key "os_cmd_gets", "os_gets"
  add_foreign_key "os_dos", "aos_pxies"
  add_foreign_key "os_dos", "flie_os"
  add_foreign_key "os_dos", "os_cmds"
  add_foreign_key "os_dos", "os_gets"
<<<<<<< HEAD
=======
>>>>>>> 775cc84 (add flie_os)
=======
>>>>>>> dc2acd4 (add os_dos)
  add_foreign_key "os_logs", "flie_os"
  add_foreign_key "pxy_excepts", "aos_pxies"
  add_foreign_key "pxy_excepts", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "yous", "flie_os"
  add_foreign_key "yous", "users"
end
