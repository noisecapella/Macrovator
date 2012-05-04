class CreateCutActionTypes < ActiveRecord::Migration
  def self.up
    create_table :cut_action_types do |t|
    end
    create_citier_view(CutActionType)
  end

  def self.down
    drop_citier_view(CutActionType)
    drop_table :cut_action_types
  end
end
