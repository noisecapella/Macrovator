class CreatePasteActionTypes < ActiveRecord::Migration
  def self.up
    create_table :paste_action_types do |t|
    end
    create_citier_view(PasteActionType)
  end

  def self.down
    drop_citier_view(PasteActionType)
    drop_table :paste_action_types
  end
end
