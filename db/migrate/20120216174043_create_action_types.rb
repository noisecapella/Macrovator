class CreateActionTypes < ActiveRecord::Migration
  def change
    create_table :action_types do |t|
      t.integer :action_type
      t.integer :action_list_id
      t.integer :position

      t.timestamps
    end
  end
end
