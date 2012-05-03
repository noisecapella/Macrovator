class ActionType < ActiveRecord::Base
  default_scope order('position ASC')

  belongs_to :action_list
  has_many :arguments, :dependent => :destroy
  accepts_nested_attributes_for :arguments, :allow_destroy => true, :reject_if => lambda { |a| a[:key].blank? or a[:value].blank? }

  attr_accessible :action_type, :action_list, :action_list_id, :action_type, :arguments_attributes, :position

  validates :action_type, :inclusion => {:in => Action::ActionMap.keys, :message => "Invalid action type"}
  validates :action_list_id, :presence => true
  validates :position, :presence => true
  #validates :arguments, :presence => true

  def my_name
    action = Action::ActionMap[action_type]
    action ? action.to_s : "Undefined"
  end

  def description
    action = Action::ActionMap[action_type]
    action ? action.describe(arguments) : "Undefined"
    
  end

  def process(user, args)
    action = Action::ActionMap[action_type]
    action.process(user, args)
  end
end
