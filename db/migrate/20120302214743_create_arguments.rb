class CreateArguments < ActiveRecord::Migration
  def change
    create_table :arguments do |t|
      t.string :key
      t.string :value
      t.references :action_type

      t.timestamps
    end
    add_index :arguments, :action_type_id
  end
end
