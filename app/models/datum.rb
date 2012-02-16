class Datum < ActiveRecord::Base
  belongs_to :user
  has_one :action_list
end
