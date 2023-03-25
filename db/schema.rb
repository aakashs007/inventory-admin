# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_03_21_103614) do
  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.integer "resource_id"
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_type_id"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
    t.index ["user_type_id"], name: "index_admin_users_on_user_type_id"
  end

  create_table "order_products", force: :cascade do |t|
    t.string "serial_number"
    t.string "model_number"
    t.integer "order_id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.index ["order_id"], name: "index_order_products_on_order_id"
    t.index ["product_id"], name: "index_order_products_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "status"
    t.integer "transfer_type"
    t.integer "order_type"
    t.integer "payment_mode"
    t.string "issued_for_client_name"
    t.text "issued_for_client_address"
    t.string "issued_for_client_pincode"
    t.string "service_report_number"
    t.string "delievery_challan_number"
    t.datetime "sent_at"
    t.datetime "recieved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sent_from_user_id", null: false
    t.integer "sent_to_user_id"
    t.integer "parent_order_id"
    t.integer "issued_to_warehouse_id"
    t.index ["sent_from_user_id"], name: "index_orders_on_sent_from_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true
    t.string "slug"
    t.float "price", default: 0.0
    t.float "vat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "supplier_id"
    t.integer "unit"
  end

  create_table "stocks", force: :cascade do |t|
    t.integer "quantity", default: 0
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "warehouse_id", null: false
    t.index ["product_id"], name: "index_stocks_on_product_id"
    t.index ["warehouse_id"], name: "index_stocks_on_warehouse_id"
  end

  create_table "user_infos", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "age"
    t.integer "latitude"
    t.integer "longitude"
    t.string "phone_number"
    t.integer "gender"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_infos_on_user_id"
  end

  create_table "user_types", force: :cascade do |t|
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.integer "user_type_id"
    t.integer "warehouse_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_type_id"], name: "index_users_on_user_type_id"
  end

  create_table "warehouses", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "pincode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "admin_users", "user_types", on_delete: :cascade
  add_foreign_key "order_products", "orders"
  add_foreign_key "order_products", "products"
  add_foreign_key "orders", "orders", column: "parent_order_id", on_delete: :cascade
  add_foreign_key "orders", "users", column: "sent_from_user_id"
  add_foreign_key "orders", "users", column: "sent_to_user_id"
  add_foreign_key "orders", "warehouses", column: "issued_to_warehouse_id"
  add_foreign_key "products", "users", column: "supplier_id"
  add_foreign_key "stocks", "products"
  add_foreign_key "stocks", "warehouses"
  add_foreign_key "user_infos", "users"
  add_foreign_key "users", "user_types", on_delete: :cascade
  add_foreign_key "users", "warehouses"
end
