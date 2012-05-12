class CreateBeginActionTypes < ActiveRecord::Migration
  def self.up
    create_table :begin_action_types do |t|
    end
  end

  def self.down
    drop_table :begin_action_types
  end
end
