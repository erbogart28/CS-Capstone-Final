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

ActiveRecord::Schema.define(version: 20170505035219) do

  create_table "completed_courses", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_deliveries", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "course_term"
    t.string   "course_frequency"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "course_frequencies", force: :cascade do |t|
    t.string   "frequency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_terms", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string   "course_code"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "degree_reqs", force: :cascade do |t|
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "degrees", force: :cascade do |t|
    t.string   "major"
    t.string   "concentration"
    t.integer  "degree_reqs_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "path_courses", force: :cascade do |t|
    t.integer  "path_id"
    t.integer  "course_id"
    t.integer  "year"
    t.string   "course_term"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "paths", force: :cascade do |t|
    t.integer  "degree_id"
    t.string   "start_quarter"
    t.integer  "course_load"
    t.integer  "in_class"
    t.integer  "online"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "prereqs", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "prereq_course_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password"
    t.string   "permission"
    t.string   "view_as"
    t.string   "first"
    t.string   "last"
    t.string   "email"
    t.integer  "degree_id"
    t.integer  "course_load"
    t.integer  "in_class"
    t.integer  "online"
    t.integer  "path_id"
    t.integer  "deleted"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.integer  "role"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
