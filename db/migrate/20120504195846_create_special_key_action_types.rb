class CreateSpecialKeyActionTypes < ActiveRecord::Migration
  def self.up
    create_table :special_key_action_types do |t|
      t.integer :keytype
    end
    create_citier_view(SpecialKeyActionType)
  end
  def self.down
    drop_citier_view(SpecialKeyActionType)
    drop_table :special_key_action_types
  end
end
