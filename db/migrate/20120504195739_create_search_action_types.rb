class CreateSearchActionTypes < ActiveRecord::Migration
  def self.up
    create_table :search_action_types do |t|
      t.string :search_key
    end
    create_citier_view(SearchActionType)
  end

  def self.down
    drop_citier_view(SearchActionType)
    drop_table :search_action_types
  end
end
