class SearchAction < Action
  Arguments = [
               {:key => "term", :default => "", :optional => false}
              ]
  Id = 1
  Name = "Search"

  def self.do_describe(args)
    "Search for '" + args.first.value.to_s + "'"
  end

  def self.do_process(user_state, args)
    key = args.first.value.to_s
    data = user_state.temp_current_data

    index = data.index(key, user_state.temp_highlight_start)
    if index.nil?
      user_state.temp_highlight_start = 0
      user_state.temp_highlight_length = 0
      raise "Search failed, could not find '" + key + "'"
    else
      user_state.temp_highlight_start = index
      user_state.temp_highlight_length = key.length
    end
  end
end
