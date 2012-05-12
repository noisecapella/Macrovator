class CreatePasteActionTypes < ActiveRecord::Migration
  def self.up
    create_table :paste_action_types do |t|
    end
  end

  def self.down
    drop_table :paste_action_types
  end
end
