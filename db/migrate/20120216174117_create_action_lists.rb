class CreateActionLists < ActiveRecord::Migration
  def change
    create_table :action_lists do |t|
      t.references :datum
      t.string :name

      t.timestamps
    end
    add_index :action_lists, :datum_id
  end
end
