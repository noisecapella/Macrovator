class CreateUserStates < ActiveRecord::Migration
  def change
    create_table :user_states do |t|
      t.integer :current_action_list_index
      t.references :current_action_list
      t.text :temp_current_data
      t.integer :temp_highlight_start
      t.integer :temp_highlight_length
      t.integer :current_position
      t.integer :last_mark_position
      t.string :last_errors


      t.references :user

      t.timestamps
    end
    add_index :user_states, :user_id
    add_index :user_states, :current_action_list_id
  end
end
