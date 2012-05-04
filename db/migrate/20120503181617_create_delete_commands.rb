class CreateDeleteCommands < ActiveRecord::Migration
  def self.up
    create_table :delete_commands do |t|
    end

    create_citier_view(DeleteCommand)
  end

  def self.down
    drop_citier_view(DeleteCommand)
    drop_table :delete_commands
  end
end
