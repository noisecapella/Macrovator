class CreateCutActionTypes < ActiveRecord::Migration
  def self.up
    create_table :cut_action_types do |t|
    end
  end

  def self.down
    drop_table :cut_action_types
  end
end
