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

ActiveRecord::Schema.define(version: 20160107220503) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actuals", force: :cascade do |t|
    t.date     "period"
    t.string   "cost_centre_description"
    t.integer  "account"
    t.string   "account_description"
    t.string   "account_type"
    t.string   "reference"
    t.string   "customer_or_supplier"
    t.date     "gl_date"
    t.string   "po_number"
    t.text     "description"
    t.integer  "debit"
    t.integer  "credit"
    t.integer  "total"
    t.integer  "cost_centre"
    t.string   "team"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "allocations", force: :cascade do |t|
    t.date     "date"
    t.decimal  "amount",     precision: 10, scale: 2
    t.integer  "role_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "title"
    t.string   "role_type"
    #t.integer  "monthly_cost"
    t.decimal  "apr"
    t.decimal  "may"
    t.decimal  "jun"
    t.decimal  "jul"
    t.decimal  "aug"
    t.decimal  "sep"
    t.decimal  "oct"
    t.decimal  "nov"
    t.decimal  "dec"
    t.decimal  "jan"
    t.decimal  "feb"
    t.decimal  "mar"
    t.text     "comments"
    t.string   "function"
    t.string   "team"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "monthly_cost_pennies",  default: 0,     null: false
    t.string   "monthly_cost_currency", default: "GBP", null: false
    t.date     "start_date"
    t.date     "end_date"
    t.string   "staff_number"
    t.integer  "group_id"
    t.integer  "team_id"
    t.string   "sub_team"
    #t.integer  "total_cost"
    t.integer  "total_cost_pennies",    default: 0,     null: false
    t.string   "total_cost_currency",   default: "GBP", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "teams", ["group_id"], name: "index_teams_on_group_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "teams", "groups"
end
