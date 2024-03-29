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

ActiveRecord::Schema.define(version: 20150307135242) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authen_codes", force: true do |t|
    t.string   "code"
    t.integer  "authen_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "authen_codes", ["user_id"], name: "index_authen_codes_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password"
    t.string   "session_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "balance"
  end

end
