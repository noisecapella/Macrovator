class Argument < ActiveRecord::Base
  validates :key, :presence => true
  validates :value, :presence => true
  #validates :action_type, :presence => true

  attr_accessible :key, :value

  belongs_to :action_type
end
