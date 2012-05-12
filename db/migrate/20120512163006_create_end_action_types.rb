class CreateEndActionTypes < ActiveRecord::Migration
  def self.up
    create_table :end_action_types do |t|
    end
    create_citier_view(EndActionType)
  end

  def self.down
    drop_citier_view(EndActionType)
    drop_table :end_action_types
  end
end
