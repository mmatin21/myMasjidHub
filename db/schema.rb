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

ActiveRecord::Schema[7.0].define(version: 2024_11_12_022013) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendees", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "phone_number"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_attendees_on_email", unique: true
    t.index ["reset_password_token"], name: "index_attendees_on_reset_password_token", unique: true
  end

  create_table "balances", force: :cascade do |t|
    t.date "date"
    t.decimal "amount"
    t.bigint "masjid_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["masjid_id"], name: "index_balances_on_masjid_id"
  end

  create_table "donations", force: :cascade do |t|
    t.bigint "fundraiser_id", null: false
    t.bigint "masjid_id", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.string "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone_number"
    t.index ["fundraiser_id"], name: "index_donations_on_fundraiser_id"
    t.index ["masjid_id"], name: "index_donations_on_masjid_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "masjid_id"
    t.string "name"
    t.text "description"
    t.datetime "event_date"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["masjid_id"], name: "index_events_on_masjid_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "masjid_id"
    t.string "name"
    t.decimal "amount", precision: 10, scale: 2
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["masjid_id"], name: "index_expenses_on_masjid_id"
  end

  create_table "fundraisers", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "goal_amount", precision: 10, scale: 2
    t.bigint "masjid_id", null: false
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["masjid_id"], name: "index_fundraisers_on_masjid_id"
  end

  create_table "masjid_attendees", force: :cascade do |t|
    t.bigint "attendee_id", null: false
    t.bigint "masjid_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendee_id"], name: "index_masjid_attendees_on_attendee_id"
    t.index ["masjid_id"], name: "index_masjid_attendees_on_masjid_id"
  end

  create_table "masjids", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "email"
    t.index ["reset_password_token"], name: "index_masjids_on_reset_password_token", unique: true
  end

  create_table "mosques", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.string "email"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prayers", force: :cascade do |t|
    t.bigint "masjid_id", null: false
    t.string "name"
    t.time "adhaan"
    t.time "iqaamah"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["masjid_id"], name: "index_prayers_on_masjid_id"
  end

  create_table "revenues", force: :cascade do |t|
    t.bigint "masjid_id"
    t.string "name"
    t.decimal "amount", precision: 10, scale: 2
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["masjid_id"], name: "index_revenues_on_masjid_id"
  end

  add_foreign_key "balances", "masjids"
  add_foreign_key "donations", "fundraisers"
  add_foreign_key "donations", "masjids"
  add_foreign_key "fundraisers", "masjids"
  add_foreign_key "masjid_attendees", "attendees"
  add_foreign_key "masjid_attendees", "masjids"
  add_foreign_key "prayers", "masjids"
end
