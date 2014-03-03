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

ActiveRecord::Schema.define(version: 20140303220756) do

  create_table "documents", force: true do |t|
    t.string   "title",      null: false
    t.string   "file",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "label_id"
    t.text     "text"
    t.integer  "user_id"
  end

  add_index "documents", ["label_id"], name: "index_documents_on_label_id"
  add_index "documents", ["user_id"], name: "index_documents_on_user_id"

  create_table "labels", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "labels", ["user_id"], name: "index_labels_on_user_id"

  create_table "pages", force: true do |t|
    t.integer  "number",      null: false
    t.string   "snapshot",    null: false
    t.integer  "document_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name", null: false
    t.string   "last_name",  null: false
    t.string   "email",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "classifier"
  end

end
