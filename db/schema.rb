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

ActiveRecord::Schema.define(version: 20161027080654) do

  create_table "states", force: :cascade do |t|
    t.float    "percent_clinton",  limit: 24
    t.float    "percent_trump",    limit: 24
    t.boolean  "pollster"
    t.boolean  "jill_on_ballot"
    t.boolean  "jill_write_in"
    t.string   "pollster_dump",    limit: 255
    t.boolean  "splits_vote"
    t.boolean  "can_I_vote"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "updated_538"
    t.datetime "pollster_updated"
    t.string   "state_long",       limit: 255
    t.string   "state_short",      limit: 255
  end

end
