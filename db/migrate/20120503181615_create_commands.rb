class CreateCommands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.integer :command_type
      t.integer :order

      t.timestamps
    end
  end
end
