class ActionType < ActiveRecord::Base
  belongs_to :action_list

  attr_accessible :action_type, :action_list, :action_list_id, :action_type

  #validates :action_type, :inclusion => {:in => all_keys, :message => "Invalid action type"}

  # constants go here
  ACTION_SEARCH = 1
  ACTION_CUT = 2
  ACTION_PASTE = 3

  MAPPING = {ACTION_SEARCH => "Search",
    ACTION_CUT => "Cut",
    ACTION_PASTE => "Paste"}

  def my_name
    MAPPING[action_type] or "Undefined"
  end

  def self.all_keys
    MAPPING.keys
  end

  def self.mapping
    MAPPING
  end
end
