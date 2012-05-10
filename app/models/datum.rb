class Datum < ActiveRecord::Base
  belongs_to :user
  has_one :action_list
  attr_accessible :user, :title, :content, :source_type, :url_refresh_count, :url

  SourceTypes = {"Single piece of data" => "from_clip", "One download from URL" => "download_url", "Live data from URL" => "live_url"}

  validates :user, :presence => true
  validates :title, :presence => true
  # validates :content, :presence => true
  validates :action_list, :presence => true
  validates :source_type, :inclusion => { :in => SourceTypes.values }

  def retrieve_content
    if self.source_type == "live_url" or (self.source_type == "download_url" and (self.url_refresh_count.nil? or self.url_refresh_count < 1))
      # TODO: this is a pretty bad solution. improve it

      self.content = ""
      uri = URI.parse(self.url)
      Net::HTTP.start(uri.host, uri.port) do |http|
        http.request_get(uri.path) do |res|
          res.read_body do |seg|
            self.content << seg

            sleep 0.005
          end
        end
      end

      if self.url_refresh_count.nil?
        self.url_refresh_count = 1
      else
        self.url_refresh_count += 1
      end

      if not self.save
        raise "Cannot save user state content"
      end
    end
    self.content
  end

end
