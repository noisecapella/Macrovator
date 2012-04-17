class User < ActiveRecord::Base
  has_many :data

  attr_accessible :name, :email, :password, :password_confirmation
  attr_accessible :current_action_list_index, :current_action_list_id
  attr_accessible :temp_current_data
  attr_accessible :temp_highlight_start, :temp_highlight_length

  has_secure_password
  validates :password, :presence => true, :length => { :minimum => 5 }
  validates :email, :uniqueness => true

  def current_action_list
    ActionList.find_by_id(current_action_list_id)
  end
end
