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

ActiveRecord::Schema.define(:version => 20120512163006) do

  create_table "action_lists", :force => true do |t|
    t.integer  "datum_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "action_lists", ["datum_id"], :name => "index_action_lists_on_datum_id"

  create_table "action_types", :force => true do |t|
    t.integer  "action_list_id"
    t.integer  "position"
    t.string   "type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "action_types", ["action_list_id"], :name => "index_action_types_on_action_list_id"

  create_table "begin_action_types", :force => true do |t|
  end

  create_table "commands", :force => true do |t|
    t.string   "type"
    t.integer  "order"
    t.integer  "user_state_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "commands", ["user_state_id"], :name => "index_commands_on_user_state_id"

  create_table "cut_action_types", :force => true do |t|
  end

  create_table "data", :force => true do |t|
    t.text     "content"
    t.text     "title"
    t.integer  "user_id"
    t.string   "source_type"
    t.string   "url"
    t.integer  "url_refresh_count"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "data", ["user_id"], :name => "index_data_on_user_id"

  create_table "delete_commands", :force => true do |t|
  end

  create_table "end_action_types", :force => true do |t|
  end

  create_table "insert_commands", :force => true do |t|
    t.integer "insert_index"
  end

  create_table "key_press_action_types", :force => true do |t|
    t.string "keys"
  end

  create_table "modified_key_action_types", :force => true do |t|
    t.integer "metakeys"
  end

  create_table "paste_action_types", :force => true do |t|
  end

  create_table "search_action_types", :force => true do |t|
    t.string "search_key"
  end

  create_table "special_key_action_types", :force => true do |t|
    t.integer "keytype"
  end

  create_table "user_states", :force => true do |t|
    t.integer  "current_action_list_index"
    t.integer  "current_action_list_id"
    t.text     "temp_current_data"
    t.integer  "temp_highlight_start"
    t.integer  "temp_highlight_length"
    t.integer  "current_position"
    t.integer  "last_mark_position"
    t.string   "last_errors"
    t.integer  "user_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "user_states", ["current_action_list_id"], :name => "index_user_states_on_current_action_list_id"
  add_index "user_states", ["user_id"], :name => "index_user_states_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_view "view_begin_action_types", "CREATE VIEW \"view_begin_action_types\" AS SELECT action_types.id, \"action_list_id\",\"position\",\"type\",\"created_at\",\"updated_at\" FROM action_types, begin_action_types WHERE action_types.id = begin_action_types.id", :force => true do |v|
    v.column :id
    v.column :action_list_id
    v.column :position
    v.column :type
    v.column :created_at
    v.column :updated_at
  end

  create_view "view_cut_action_types", "CREATE VIEW \"view_cut_action_types\" AS SELECT action_types.id, \"action_list_id\",\"position\",\"type\",\"created_at\",\"updated_at\" FROM action_types, cut_action_types WHERE action_types.id = cut_action_types.id", :force => true do |v|
    v.column :id
    v.column :action_list_id
    v.column :position
    v.column :type
    v.column :created_at
    v.column :updated_at
  end

  create_view "view_delete_commands", "CREATE VIEW \"view_delete_commands\" AS SELECT commands.id, \"type\",\"order\",\"user_state_id\",\"created_at\",\"updated_at\" FROM commands, delete_commands WHERE commands.id = delete_commands.id", :force => true do |v|
    v.column :id
    v.column :type
    v.column :order
    v.column :user_state_id
    v.column :created_at
    v.column :updated_at
  end

  create_view "view_end_action_types", "CREATE VIEW \"view_end_action_types\" AS SELECT action_types.id, \"action_list_id\",\"position\",\"type\",\"created_at\",\"updated_at\" FROM action_types, end_action_types WHERE action_types.id = end_action_types.id", :force => true do |v|
    v.column :id
    v.column :action_list_id
    v.column :position
    v.column :type
    v.column :created_at
    v.column :updated_at
  end

  create_view "view_insert_commands", "CREATE VIEW \"view_insert_commands\" AS SELECT commands.id, \"type\",\"order\",\"user_state_id\",\"created_at\",\"updated_at\",\"insert_index\" FROM commands, insert_commands WHERE commands.id = insert_commands.id", :force => true do |v|
    v.column :id
    v.column :type
    v.column :order
    v.column :user_state_id
    v.column :created_at
    v.column :updated_at
    v.column :insert_index
  end

  create_view "view_key_press_action_types", "CREATE VIEW \"view_key_press_action_types\" AS SELECT action_types.id, \"action_list_id\",\"position\",\"type\",\"created_at\",\"updated_at\",\"keys\" FROM action_types, key_press_action_types WHERE action_types.id = key_press_action_types.id", :force => true do |v|
    v.column :id
    v.column :action_list_id
    v.column :position
    v.column :type
    v.column :created_at
    v.column :updated_at
    v.column :keys
  end

  create_view "view_modified_key_action_types", "CREATE VIEW \"view_modified_key_action_types\" AS SELECT view_key_press_action_types.id, \"action_list_id\",\"position\",\"type\",\"created_at\",\"updated_at\",\"keys\",\"metakeys\" FROM view_key_press_action_types, modified_key_action_types WHERE view_key_press_action_types.id = modified_key_action_types.id", :force => true do |v|
    v.column :id
    v.column :action_list_id
    v.column :position
    v.column :type
    v.column :created_at
    v.column :updated_at
    v.column :keys
    v.column :metakeys
  end

  create_view "view_paste_action_types", "CREATE VIEW \"view_paste_action_types\" AS SELECT action_types.id, \"action_list_id\",\"position\",\"type\",\"created_at\",\"updated_at\" FROM action_types, paste_action_types WHERE action_types.id = paste_action_types.id", :force => true do |v|
    v.column :id
    v.column :action_list_id
    v.column :position
    v.column :type
    v.column :created_at
    v.column :updated_at
  end

  create_view "view_search_action_types", "CREATE VIEW \"view_search_action_types\" AS SELECT action_types.id, \"action_list_id\",\"position\",\"type\",\"created_at\",\"updated_at\",\"search_key\" FROM action_types, search_action_types WHERE action_types.id = search_action_types.id", :force => true do |v|
    v.column :id
    v.column :action_list_id
    v.column :position
    v.column :type
    v.column :created_at
    v.column :updated_at
    v.column :search_key
  end

  create_view "view_special_key_action_types", "CREATE VIEW \"view_special_key_action_types\" AS SELECT action_types.id, \"action_list_id\",\"position\",\"type\",\"created_at\",\"updated_at\",\"keytype\" FROM action_types, special_key_action_types WHERE action_types.id = special_key_action_types.id", :force => true do |v|
    v.column :id
    v.column :action_list_id
    v.column :position
    v.column :type
    v.column :created_at
    v.column :updated_at
    v.column :keytype
  end

end
