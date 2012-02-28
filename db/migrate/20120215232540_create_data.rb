class CreateData < ActiveRecord::Migration
  def change
    create_table :data do |t|
      t.text :content
      t.text :title
      t.integer :user_id

      t.timestamps
    end
  end
end
