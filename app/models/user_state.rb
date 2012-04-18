class UserState < ActiveRecord::Base
  belongs_to :user

  attr_accessible :current_action_list_index, :current_action_list_id
  attr_accessible :temp_current_data
  attr_accessible :temp_highlight_start, :temp_highlight_length

  attr_accessible :user

  validates :user, :presence => true

  def current_action_list
    ActionList.find_by_id(current_action_list_id)
  end

end
