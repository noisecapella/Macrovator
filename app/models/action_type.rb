class ActionType < ActiveRecord::Base
  belongs_to :action_list

  # constants go here
  ACTION_SEARCH = 1
  ACTION_CUT = 2
  ACTION_PASTE = 3

  @names = {ACTION_SEARCH: "Search",
    ACTION_CUT: "Cut",
    ACTION_PASTE: "Paste"}

  def name
    names[action_type] or "Undefined"
  end

  def symbols
    names.keys
  end

  def self.all_action_types
    @names.map { |k,v| [v,k] }
  end
end
