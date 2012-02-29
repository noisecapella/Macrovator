class Datum < ActiveRecord::Base
  belongs_to :user
  has_one :action_list
  attr_accessible :user, :title, :content

  validates :user, :presence => true
  validates :title, :presence => true
  validates :content, :presence => true
  validates :action_list, :presence => true
end
