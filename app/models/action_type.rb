class ActionType < ActiveRecord::Base
  belongs_to :action_list
  has_many :arguments, :dependent => :destroy
  accepts_nested_attributes_for :arguments, :allow_destroy => true, :reject_if => lambda { |a| a[:key].blank? or a[:value].blank? }

  attr_accessible :action_type, :action_list, :action_list_id, :action_type, :arguments_attributes

  validates :action_type, :inclusion => {:in => Constants::ActionMap.keys, :message => "Invalid action type"}
  validates :action_list_id, :presence => true
  #validates :arguments, :presence => true

  def my_name
    action = Constants::ActionMap[action_type]
    action ? action.to_s : "Undefined"
  end

  def description
    action = Constants::ActionMap[action_type]
    action ? action.describe(arguments) : "Undefined"
    
  end
end
