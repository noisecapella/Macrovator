class CreateEndActionTypes < ActiveRecord::Migration
  def self.up
    create_table :end_action_types do |t|
    end
  end

  def self.down
    drop_table :end_action_types
  end
end
