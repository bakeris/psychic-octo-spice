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

ActiveRecord::Schema.define(version: 20150821142040) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "civilities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "creation_modes", force: true do |t|
    t.string   "name"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parameters", force: true do |t|
    t.string   "registration_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_password_url"
    t.string   "ail_username"
    t.string   "ail_password"
    t.string   "ail_terminal_id"
  end

  create_table "query_bets", force: true do |t|
    t.integer  "user_id"
    t.integer  "confirm_id"
    t.datetime "op_code"
    t.string   "bet_code"
    t.string   "bet_modifier"
    t.string   "selector1"
    t.string   "selector2"
    t.string   "repeats"
    t.string   "special_count"
    t.string   "normal_count"
    t.string   "entries"
    t.string   "status"
    t.string   "response_message_id"
    t.string   "response_user_id"
    t.string   "response_datetime"
    t.string   "audit_number"
    t.float    "bet_cost_amount"
    t.string   "response_bet_code"
    t.string   "response_bet_modifier"
    t.string   "response_selector1"
    t.string   "response_selector2"
    t.string   "response_repeats"
    t.string   "response_special_count"
    t.string   "response_normal_count"
    t.string   "response_entries"
    t.string   "error_code"
    t.text     "error_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sexes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.integer  "civility_id"
    t.integer  "sex_id"
    t.string   "pseudo"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "password"
    t.date     "birthdate"
    t.integer  "creation_mode_id"
    t.string   "reset_password_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "password_reseted_at"
    t.boolean  "account_enabled"
    t.string   "msisdn",                 limit: 20
    t.string   "uuid"
    t.string   "last_succesful_message"
    t.string   "integer"
    t.string   "paymoney_password"
    t.string   "account_label"
  end

  add_index "users", ["civility_id"], name: "index_users_on_civility_id", using: :btree
  add_index "users", ["creation_mode_id"], name: "index_users_on_creation_mode_id", using: :btree
  add_index "users", ["sex_id"], name: "index_users_on_sex_id", using: :btree

end
