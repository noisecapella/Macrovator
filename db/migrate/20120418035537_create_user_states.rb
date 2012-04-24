class CreateUserStates < ActiveRecord::Migration
  def change
    create_table :user_states do |t|
      t.integer :current_action_list_index
      t.integer :current_action_list_id
      t.text :temp_current_data
      t.integer :temp_highlight_start
      t.integer :temp_highlight_length
      t.integer :current_position
      t.integer :last_mark_position


      t.integer :user_id

      t.timestamps
    end
  end
end
