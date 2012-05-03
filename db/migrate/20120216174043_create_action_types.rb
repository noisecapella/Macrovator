class CreateActionTypes < ActiveRecord::Migration
  def change
    create_table :action_types do |t|
      t.integer :action_type
      t.references :action_list
      t.integer :position

      t.timestamps
    end
    add_index :action_types, :action_list_id
  end
end
