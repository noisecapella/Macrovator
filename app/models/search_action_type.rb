class SearchActionType < ActionType
  acts_as_citier

  attr_accessible :search_key

  def describe
    "Search for '#{self.search_key}'"
  end

  def process(user_state)
    key = self.search_key
    data = user_state.temp_current_data

    index = data.index(key, user_state.current_position)
    if index.nil?
      user_state.temp_highlight_start = 0
      user_state.temp_highlight_length = 0
      raise "Search failed, could not find '" + key + "'"
    else
      user_state.temp_highlight_start = index
      user_state.temp_highlight_length = key.length
      user_state.current_position = index
    end
  end

  def self.my_name
    "Search"
  end

  def make_arguments
    [
     Argument.new("search_key", "Search", self.search_key)
    ]
  end
end
