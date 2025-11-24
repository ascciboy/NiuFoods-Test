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

ActiveRecord::Schema[8.1].define(version: 2025_11_23_185600) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "device_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "details"
    t.bigint "device_id", null: false
    t.string "new_status", null: false
    t.string "previous_status", null: false
    t.datetime "processed_at"
    t.datetime "reported_at"
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_device_logs_on_device_id"
    t.index ["new_status"], name: "index_device_logs_on_new_status"
    t.index ["reported_at"], name: "index_device_logs_on_reported_at"
  end

  create_table "device_types", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.boolean "requires_network", default: false, null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_device_types_on_name", unique: true
  end

  create_table "devices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "critical", default: false, null: false
    t.bigint "device_type_id", null: false
    t.string "firmware_version"
    t.string "ip_address"
    t.boolean "is_network_reachable", default: false
    t.datetime "last_connection_at"
    t.string "location"
    t.string "name", null: false
    t.bigint "restaurant_id", null: false
    t.string "status", default: "unknown", null: false
    t.datetime "updated_at", null: false
    t.index ["critical"], name: "index_devices_on_critical"
    t.index ["device_type_id"], name: "index_devices_on_device_type_id"
    t.index ["restaurant_id", "name"], name: "index_devices_on_restaurant_id_and_name", unique: true
    t.index ["restaurant_id"], name: "index_devices_on_restaurant_id"
    t.index ["status"], name: "index_devices_on_status"
  end

  create_table "restaurants", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "city", null: false
    t.datetime "created_at", null: false
    t.integer "critical_issues_count", default: 0
    t.integer "issues_count", default: 0
    t.datetime "last_report_at"
    t.string "name", null: false
    t.string "status", default: "Unknown", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_restaurants_on_active"
    t.index ["status"], name: "index_restaurants_on_status"
  end

  add_foreign_key "device_logs", "devices"
  add_foreign_key "devices", "device_types"
  add_foreign_key "devices", "restaurants"
end
