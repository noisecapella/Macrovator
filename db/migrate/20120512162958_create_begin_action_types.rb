class CreateBeginActionTypes < ActiveRecord::Migration
  def self.up
    create_table :begin_action_types do |t|
    end
    create_citier_view(BeginActionType)
  end

  def self.down
    drop_citier_view(BeginActionType)
    drop_table :begin_action_types
  end
end
