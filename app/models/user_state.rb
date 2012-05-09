require 'net/http'
require 'uri'

class UserState < ActiveRecord::Base
  belongs_to :user

  attr_accessible :current_action_list_index
  attr_accessible :current_action_list_id
  attr_accessible :temp_current_data
  attr_accessible :temp_highlight_start, :temp_highlight_length
  attr_accessible :current_position, :last_mark_position
  attr_accessible :last_errors
  attr_accessible :commands
  has_many :commands

  attr_accessible :user

  validates :user, :presence => true

  def current_action_list
    ActionList.find(current_action_list_id)
  end

  def reset_count(new_action_list_id)
    self.current_action_list_id = new_action_list_id
    self.current_action_list_index = 0
    self.current_position = 0
    self.last_mark_position = 0
    self.temp_highlight_start = 0
    self.temp_highlight_length = 0
    self.last_errors = nil
  end

  def reset_text
    datum = current_action_list.datum
    if datum.source_type == "from_clip"
      self.temp_current_data = current_action_list.datum.content
    elsif datum.source_type == "live_url" or datum.source_type == "data_url"
      # TODO: this is a pretty bad solution. improve it

      self.temp_current_data = ""
      uri = URI.parse(datum.content)
      Net::HTTP.start(uri.host, uri.port) do |http|
        http.request_get(uri.path) do |res|
          res.read_body do |seg|
            self.temp_current_data << seg

            sleep 0.005
          end
        end
      end
      
      if not self.save
        raise "Cannot save user state"
      end
    end

    if datum.source_type == "data_url"
      datum.content = self.temp_current_data
      datum.source_type = "from_clip"
      if not datum.save
        raise "Cannot save data content"
      end
    end
  end

  def reset(new_action_list_id)
    reset_count(new_action_list_id)
    reset_text
    reset_commands
  end

  def reset_commands
    self.commands.each do |command|
      command.destroy
    end
  end

  def invalid?
    #TODO: validate current_action_list_index normally
    current_action_list_index.nil? or current_action_list_index >= current_action_list.action_types.count
  end

  def in_progress?
    current_action_list_index > 0
  end
  
end
