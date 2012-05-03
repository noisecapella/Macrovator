class CreateCommandArguments < ActiveRecord::Migration
  def change
    create_table :command_arguments do |t|
      t.string :key
      t.string :value
      t.references :command

      t.timestamps
    end
    add_index :command_arguments, :command_id
  end
end
