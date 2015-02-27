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

ActiveRecord::Schema.define(version: 20150225205635) do

  create_table "apps", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "appKey"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apps", ["user_id"], name: "index_apps_on_user_id"

  create_table "events", force: true do |t|
    t.integer  "position_id"
    t.integer  "user_id"
    t.datetime "eventDate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "desc"
  end

  add_index "events", ["position_id"], name: "index_events_on_position_id"
  add_index "events", ["user_id"], name: "index_events_on_user_id"

  create_table "positions", force: true do |t|
    t.string   "name"
    t.string   "lng"
    t.string   "lat"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_on_events", force: true do |t|
    t.integer  "tag_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tag_on_events", ["event_id"], name: "index_tag_on_events_on_event_id"
  add_index "tag_on_events", ["tag_id"], name: "index_tag_on_events_on_tag_id"

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.boolean  "isAdmin",         default: false
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
