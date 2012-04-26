class ActionList < ActiveRecord::Base
  belongs_to :datum
  has_many :action_types

  attr_accessible :datum, :action_types, :name

  validates :datum, :presence => true
  validates :name, :presence => true

end
