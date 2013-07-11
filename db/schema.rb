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

ActiveRecord::Schema.define(:version => 20130711173858) do

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "remember_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "widget_preferences", :force => true do |t|
    t.string  "background_color"
    t.text    "todo_tasks"
    t.string  "weather_city"
    t.string  "weather_state"
    t.string  "rss_feed"
    t.string  "gmail_access_token"
    t.string  "gmail_address"
    t.string  "gmail_refresh_token"
    t.string  "gmail_expires_in"
    t.integer "widget_id"
    t.text    "notes"
  end

  add_index "widget_preferences", ["widget_id"], :name => "index_widget_preferences_on_widget_id"

  create_table "widgets", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.text     "properties"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "widgets", ["user_id"], :name => "index_widgets_on_user_id"

end
