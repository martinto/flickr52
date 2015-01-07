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

ActiveRecord::Schema.define(version: 20150107072707) do

  create_table "challenges", force: true do |t|
    t.date     "year"
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "flickr_id"
  end

  create_table "challenges_members", id: false, force: true do |t|
    t.integer "challenge_id"
    t.integer "member_id"
  end

  add_index "challenges_members", ["challenge_id"], name: "index_challenges_members_on_challenge_id", using: :btree
  add_index "challenges_members", ["member_id"], name: "index_challenges_members_on_member_id", using: :btree

  create_table "event_logs", force: true do |t|
    t.datetime "when"
    t.string   "message"
    t.text     "backtrace"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", force: true do |t|
    t.string   "nsid"
    t.string   "username"
    t.integer  "member_type"
    t.string   "real_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", force: true do |t|
    t.integer  "flickr_id",              limit: 8
    t.integer  "challenge_id"
    t.integer  "member_id"
    t.string   "secret"
    t.string   "title"
    t.boolean  "is_public"
    t.datetime "date_added"
    t.datetime "date_uploaded"
    t.datetime "date_taken"
    t.integer  "date_taken_granularity"
    t.text     "tags"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "week_id"
  end

  create_table "weeks", force: true do |t|
    t.integer  "week_number"
    t.string   "subject"
    t.integer  "challenge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
