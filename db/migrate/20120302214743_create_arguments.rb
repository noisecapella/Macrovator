class CreateArguments < ActiveRecord::Migration
  def change
    create_table :arguments do |t|
      t.string :key
      t.string :value
      t.integer :action_type_id

      t.timestamps
    end
  end
end
