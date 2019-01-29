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

ActiveRecord::Schema.define(version: 2019_01_29_001332) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "invite_people", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.boolean "primary", default: false
    t.boolean "coming", default: true
    t.string "gender"
    t.bigint "invite_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "age"
    t.bigint "job_id"
    t.index ["invite_id"], name: "index_invite_people_on_invite_id"
    t.index ["job_id"], name: "index_invite_people_on_job_id"
  end

  create_table "invites", force: :cascade do |t|
    t.boolean "reception", default: false
    t.boolean "ask_food", default: true
    t.string "code", null: false
    t.string "food_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "rsvp", default: false
    t.string "style"
    t.string "email_address"
    t.string "street"
    t.string "suburb"
    t.string "city"
    t.string "postal_code"
    t.string "country"
    t.string "phone"
    t.datetime "invited_at"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "invite_people", "invites", on_delete: :cascade
  add_foreign_key "invite_people", "jobs", on_delete: :nullify
end
