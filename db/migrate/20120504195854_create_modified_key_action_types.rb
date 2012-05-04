class CreateModifiedKeyActionTypes < ActiveRecord::Migration
  def self.up
    create_table :modified_key_action_types do |t|
      t.integer :metakeys
    end
    create_citier_view(ModifiedKeyActionType)
  end
  def self.down
    drop_citier_view(ModifiedKeyActionType)
    drop_table :modified_key_action_types
  end
end
