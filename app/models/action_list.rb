class ActionList < ActiveRecord::Base
  belongs_to :datum
  has_many :action_types
end
