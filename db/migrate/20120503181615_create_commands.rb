class CreateCommands < ActiveRecord::Migration
  def self.up
    create_table :commands do |t|
      t.string :type
      t.integer :order
      t.references :user_state

      t.timestamps
    end
    add_index :commands, :user_state_id
  end

  def self.down
    drop_table :commands
  end
end
