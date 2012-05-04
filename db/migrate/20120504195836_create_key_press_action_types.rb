class CreateKeyPressActionTypes < ActiveRecord::Migration
  def self.up
    create_table :key_press_action_types do |t|
      t.string :keys
    end
    create_citier_view(KeyPressActionType)
  end
  def self.down
    drop_citier_view(KeyPressActionType)
    drop_table :key_press_action_types
  end
end
