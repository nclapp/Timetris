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

ActiveRecord::Schema.define(version: 20150514203740) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tasks", force: :cascade do |t|
    t.integer  "creator_id",               null: false
    t.string   "name",                     null: false
    t.integer  "time_box",    default: 15, null: false
    t.datetime "due_date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "event_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "priority",    default: 2
    t.text     "description"
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "email"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "refresh_token"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "default_time_increment", default: 15
    t.datetime "snooze_until",           default: '1776-07-04 06:00:00'
    t.datetime "last_alert",             default: '1776-07-04 06:00:00'
  end

end
