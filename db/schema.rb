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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130521181138) do

  create_table "contributions", :force => true do |t|
    t.integer  "report_id"
    t.integer  "filer_id"
    t.string   "rec_type"
    t.string   "form_type"
    t.string   "contributor_type"
    t.string   "name_title",          :limit => 25
    t.string   "name_first",          :limit => 45
    t.string   "name_last",           :limit => 100
    t.string   "name_suffix",         :limit => 10
    t.string   "address",             :limit => 55
    t.string   "address2",            :limit => 55
    t.string   "city",                :limit => 30
    t.string   "state",               :limit => 2
    t.string   "zip",                 :limit => 10
    t.boolean  "is_out_of_state_pac"
    t.string   "out_of_state_pac_id", :limit => 9
    t.date     "date"
    t.decimal  "amount",                             :precision => 12, :scale => 2
    t.string   "in_kind_description", :limit => 100
    t.string   "employer",            :limit => 60
    t.string   "occupation",          :limit => 60
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
  end

  add_index "contributions", ["filer_id"], :name => "index_contributions_on_filer_id"
  add_index "contributions", ["report_id", "form_type"], :name => "index_contributions_on_report_id_and_form_type"
  add_index "contributions", ["report_id"], :name => "index_contributions_on_report_id"

  create_table "expenditures", :force => true do |t|
    t.integer  "report_id"
    t.integer  "filer_id"
    t.string   "rec_type"
    t.string   "form_type"
    t.string   "item_id"
    t.string   "payee_type"
    t.string   "payee_name_title"
    t.string   "payee_name_first"
    t.string   "payee_name_last"
    t.string   "payee_name_suffix"
    t.string   "payee_address"
    t.string   "payee_address2"
    t.string   "payee_city"
    t.string   "payee_state"
    t.string   "payee_zip"
    t.date     "date"
    t.decimal  "amount",                    :precision => 12, :scale => 2
    t.string   "description"
    t.boolean  "reimbursement_expected"
    t.string   "candidate_name_title"
    t.string   "candidate_name_first"
    t.string   "candidate_name_last"
    t.string   "candidate_name_suffix"
    t.string   "office_held_code"
    t.string   "office_held_description"
    t.string   "office_held_district"
    t.string   "office_sought_code"
    t.string   "office_sought_description"
    t.string   "office_sought_district"
    t.string   "backreference_id"
    t.boolean  "is_corp_contrib"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
  end

  create_table "filers", :force => true do |t|
    t.integer  "user_id"
    t.string   "version"
    t.string   "filer_type"
    t.string   "name_prefix"
    t.string   "name_first"
    t.string   "name_mi"
    t.string   "name_nick"
    t.string   "name_last"
    t.string   "name_suffix"
    t.string   "address_street"
    t.string   "address_suite"
    t.string   "address_city"
    t.string   "address_state"
    t.string   "address_zip"
    t.string   "phone"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "filers", ["user_id"], :name => "index_filers_on_user_id"

  create_table "reports", :force => true do |t|
    t.integer  "filer_id"
    t.string   "coh_name_prefix"
    t.string   "coh_name_first"
    t.string   "coh_name_mi"
    t.string   "coh_name_nick"
    t.string   "coh_name_last"
    t.string   "coh_name_suffix"
    t.string   "coh_address_street"
    t.string   "coh_address_suite"
    t.string   "coh_address_city"
    t.string   "coh_address_state"
    t.string   "coh_address_zip"
    t.boolean  "coh_address_changed"
    t.string   "coh_phone"
    t.string   "treasurer_name_prefix"
    t.string   "treasurer_name_first"
    t.string   "treasurer_name_mi"
    t.string   "treasurer_name_nick"
    t.string   "treasurer_name_last"
    t.string   "treasurer_name_suffix"
    t.string   "treasurer_address_street"
    t.string   "treasurer_address_suite"
    t.string   "treasurer_address_city"
    t.string   "treasurer_address_state"
    t.string   "treasurer_address_zip"
    t.boolean  "treasurer_address_changed"
    t.string   "treasurer_phone"
    t.string   "status"
    t.string   "report_type"
    t.date     "period_begin"
    t.date     "period_end"
    t.date     "election_date"
    t.string   "election_type"
    t.string   "office_held"
    t.string   "office_sought"
    t.string   "contribution_csv_file_name"
    t.string   "contribution_csv_content_type"
    t.integer  "contribution_csv_file_size"
    t.datetime "contribution_csv_updated_at"
    t.string   "expenditure_csv_file_name"
    t.string   "expenditure_csv_content_type"
    t.integer  "expenditure_csv_file_size"
    t.datetime "expenditure_csv_updated_at"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "reports", ["filer_id"], :name => "index_reports_on_filer_id"

  create_table "treasurers", :force => true do |t|
    t.integer  "filer_id"
    t.string   "version"
    t.string   "name_prefix"
    t.string   "name_first"
    t.string   "name_mi"
    t.string   "name_nick"
    t.string   "name_last"
    t.string   "name_suffix"
    t.string   "address_street"
    t.string   "address_suite"
    t.string   "address_city"
    t.string   "address_state"
    t.string   "address_zip"
    t.string   "phone"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "treasurers", ["filer_id"], :name => "index_treasurers_on_filer_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
