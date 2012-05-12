class CreateWhileNoErrorActionTypes < ActiveRecord::Migration
  def self.up
    create_table :while_no_error_action_types do |t|
    end
  end

  def self.down
    drop_table :while_no_error_action_types
  end
end
