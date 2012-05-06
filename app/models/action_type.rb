class ActionType < ActiveRecord::Base
  default_scope order('position ASC')
  acts_as_citier

  belongs_to :action_list

  attr_accessible :action_list, :position, :type

  validates :action_list, :presence => true
  validates :position, :presence => true
  #validates :arguments, :presence => true

  #TODO: figure out a better way to do this
  def self.get_action_types
    # this can't be a constant because we can't refer to types of subclasses before they exist
    [SearchActionType, CutActionType, PasteActionType, KeyPressActionType, 
     SpecialKeyActionType, ModifiedKeyActionType]
  end

  def self.my_type
    self.to_s
  end

  Argument = Struct.new :key, :name, :value
end
