class Datum < ActiveRecord::Base
  belongs_to :user
  has_one :action_list
  attr_accessible :user, :title, :content, :source_type

  SourceTypes = {"Single piece of data" => "from_clip", "One download from URL" => "download_url", "Live data from URL" => "live_url"}

  validates :user, :presence => true
  validates :title, :presence => true
  validates :content, :presence => true
  validates :action_list, :presence => true
  validates :source_type, :inclusion => { :in => SourceTypes.values }

end
