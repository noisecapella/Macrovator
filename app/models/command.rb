class Command < ActiveRecord::Base  
  acts_as_citier
  attr_accessible :user, :order
  belongs_to :user_state
end
