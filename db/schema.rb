# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160815024735) do

  create_table "cities", force: :cascade do |t|
    t.string   "city_name"
    t.string   "province"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: :cascade do |t|
    t.string   "event_name"
    t.text     "event_description"
    t.date     "start_date"
    t.date     "registration_deadline"
    t.date     "event_date"
    t.boolean  "public_event",          default: false, null: false
    t.integer  "max_participants"
    t.decimal  "min_value"
    t.decimal  "max_value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
    t.integer  "creator_id"
    t.boolean  "targets_assigned",      default: false
  end

  add_index "events", ["city_id"], name: "index_events_on_city_id"
  add_index "events", ["creator_id"], name: "index_events_on_creator_id"

  create_table "events_users", id: false, force: :cascade do |t|
    t.integer "user_id",  null: false
    t.integer "event_id", null: false
  end

  create_table "gifts", force: :cascade do |t|
    t.string   "gift_name"
    t.text     "gift_description"
    t.decimal  "est_value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "gifts", ["user_id"], name: "index_gifts_on_user_id"

  create_table "invitations", force: :cascade do |t|
    t.string  "name"
    t.string  "email"
    t.string  "invitation_code"
    t.integer "user_id"
    t.integer "event_id"
  end

  add_index "invitations", ["event_id"], name: "index_invitations_on_event_id"
  add_index "invitations", ["user_id"], name: "index_invitations_on_user_id"

  create_table "targets", id: false, force: :cascade do |t|
    t.integer "santa_id"
    t.integer "recipient_id"
    t.integer "event_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
  end

  add_index "users", ["city_id"], name: "index_users_on_city_id"

end
