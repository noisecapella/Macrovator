class CreateInsertCommands < ActiveRecord::Migration
  def self.up
    create_table :insert_commands do |t|
      t.integer :insert_index
    end

    create_citier_view(InsertCommand)
  end

  def self.down
    drop_citier_view(InsertCommand)
    drop_table :insert_commands
  end
end
