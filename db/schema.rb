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

ActiveRecord::Schema.define(version: 20150601071331) do

  create_table "searches", force: true do |t|
    t.string   "ticker"
    t.integer  "year"
    t.integer  "filing",          default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "file_found"
    t.boolean  "file_downloaded"
    t.string   "file_name"
    t.string   "request_ip"
  end

  add_index "searches", ["request_ip"], name: "index_searches_on_request_ip", using: :btree

  create_table "stocks", force: true do |t|
    t.string   "name"
    t.string   "ticker"
    t.integer  "cik"
    t.string   "fyed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stocks", ["ticker"], name: "index_stocks_on_ticker", using: :btree

end
