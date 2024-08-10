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

ActiveRecord::Schema[7.2].define(version: 2024_08_10_014913) do
  create_table "account_balances_2024", force: :cascade do |t|
    t.decimal "account_balance"
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_balances_on_account_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.integer "account_type"
    t.decimal "cash", default: "0.0"
    t.text "description"
    t.string "financial_institution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "registered_account_limits_2024", force: :cascade do |t|
    t.decimal "tfsa_limit"
    t.decimal "rrsp_limit"
    t.decimal "tfsa_contributions", default: "0.0", null: false
    t.decimal "rrsp_contributions", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.decimal "fhsa_limit"
    t.decimal "fhsa_contributions", default: "0.0", null: false
    t.index ["user_id"], name: "index_registered_account_limits_2024_on_user_id", unique: true
  end

  create_table "stocks", force: :cascade do |t|
    t.string "symbol", null: false
    t.datetime "purchase_date", null: false
    t.decimal "share_price", null: false
    t.integer "quantity_purchased", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id", null: false
    t.index ["account_id"], name: "index_stocks_on_account_id"
  end

  create_table "transactions_2024", force: :cascade do |t|
    t.string "type"
    t.decimal "funds_value_added", default: "0.0"
    t.decimal "funds_value_removed", default: "0.0"
    t.decimal "funds_value_transferred", default: "0.0"
    t.string "stock_symbol"
    t.integer "stock_quantity", default: 0
    t.decimal "stock_value_added", default: "0.0"
    t.decimal "stock_value_removed", default: "0.0"
    t.decimal "stock_value_transferred", default: "0.0"
    t.integer "from_account_id", null: false
    t.integer "to_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_account_id"], name: "index_transactions_on_from_account_id"
    t.index ["to_account_id"], name: "index_transactions_on_to_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.boolean "admin", default: false
    t.string "password_digest"
    t.string "remember_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "account_balances_2024", "accounts"
  add_foreign_key "accounts", "users"
  add_foreign_key "registered_account_limits_2024", "users"
  add_foreign_key "stocks", "accounts"
  add_foreign_key "transactions_2024", "accounts", column: "from_account_id"
  add_foreign_key "transactions_2024", "accounts", column: "to_account_id"
end
