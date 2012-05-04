class CreateActionTypes < ActiveRecord::Migration
  def self.up
    create_table :action_types do |t|
      t.references :action_list
      t.integer :position
      t.string :type

      t.timestamps
    end
    add_index :action_types, :action_list_id
  end

  def self.down
    drop_table :action_types
  end
end
