class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :password_digest
      t.integer :temp_highlight_start
      t.integer :temp_highlight_length

      t.integer :current_action_list_id
      t.integer :current_action_list_index
      t.string :temp_current_data

      t.timestamps
    end
  end
end
