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

ActiveRecord::Schema.define(version: 20131001192955) do

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "keywords", force: true do |t|
    t.integer  "project_id", null: false
    t.string   "name",       null: false
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "keywords", ["name", "project_id"], name: "index_keywords_on_name_and_project_id", unique: true, using: :btree

  create_table "projects", force: true do |t|
    t.string   "name",                                              null: false
    t.integer  "search_depth",      default: 100,                   null: false
    t.string   "scheduler_mode",    default: "On Demand",           null: false
    t.integer  "scheduler_factor",  default: 1,                     null: false
    t.time     "scheduler_time",    default: '2000-01-01 06:00:00', null: false
    t.integer  "scheduler_day",     default: 1,                     null: false
    t.datetime "last_scheduled_at"
    t.datetime "last_scanned_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",           default: 1,                     null: false
  end

  add_index "projects", ["name", "user_id"], name: "index_projects_on_name_and_user_id", unique: true, using: :btree
  add_index "projects", ["scheduler_mode"], name: "index_projects_on_scheduler_mode", using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "projects_search_engines", id: false, force: true do |t|
    t.integer  "project_id",       null: false
    t.integer  "search_engine_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects_search_engines", ["project_id", "search_engine_id"], name: "index_projects_search_engines_on_project_id_and_search_engine_id", unique: true, using: :btree

  create_table "report_groups", force: true do |t|
    t.string   "name",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",       default: 1, null: false
    t.integer  "display_order"
  end

  add_index "report_groups", ["name", "user_id"], name: "index_report_groups_on_name_and_user_id", unique: true, using: :btree
  add_index "report_groups", ["user_id", "display_order"], name: "index_report_groups_on_user_id_and_display_order", using: :btree

  create_table "report_items", force: true do |t|
    t.integer  "report_id",       null: false
    t.string   "site",            null: false
    t.string   "keyword",         null: false
    t.string   "search_engine",   null: false
    t.string   "position",        null: false
    t.string   "position_change"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "report_items", ["site", "keyword", "search_engine"], name: "index_report_items_on_site_and_keyword_and_search_engine", using: :btree

  create_table "reports", force: true do |t|
    t.integer  "report_group_id",        null: false
    t.datetime "notification_completed"
    t.string   "status"
    t.string   "scan_errors"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reports", ["report_group_id", "created_at"], name: "index_reports_on_report_group_id_and_created_at", using: :btree

  create_table "scan_registry", force: true do |t|
    t.string   "key",           null: false
    t.string   "site",          null: false
    t.string   "keyword",       null: false
    t.string   "search_engine", null: false
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scan_registry", ["key", "site", "keyword", "search_engine"], name: "index_scan_registry", unique: true, using: :btree

  create_table "search_engines", force: true do |t|
    t.string   "name",                                null: false
    t.string   "main_url",                            null: false
    t.string   "query_input_selector",                null: false
    t.string   "item_regex",                          null: false
    t.string   "next_page_selector",                  null: false
    t.integer  "next_page_delay",      default: 15,   null: false
    t.integer  "version",              default: 0,    null: false
    t.boolean  "active",               default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "search_engines", ["active"], name: "index_search_engines_on_active", using: :btree
  add_index "search_engines", ["name"], name: "index_search_engines_on_name", unique: true, using: :btree

  create_table "settings", force: true do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "sites", force: true do |t|
    t.integer  "project_id", null: false
    t.string   "name",       null: false
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sites", ["name", "project_id"], name: "index_sites_on_name_and_project_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                             null: false
    t.string   "hashed_password",                  null: false
    t.string   "salt",                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",            default: "user", null: false
  end

  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree

end
