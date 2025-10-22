# This file is auto-generated from the current state of the database. Instead of editing this file,
# please run the migrations via `bin/rails db:migrate`. This ensures the schema remains up to date.

ActiveRecord::Schema[7.1].define(version: 20250101001000) do
  create_table "todos", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end
end
