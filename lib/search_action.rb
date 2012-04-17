class SearchAction < Action
  Arguments = [
               {:key => "term", :default => "", :optional => false}
              ]
  Id = 1
  Name = "Search"

  def self.do_describe(args)
    "Search for '" + args.first.value.to_s + "'"
  end

  def self.do_process(user, args)
    key = args.first.value.to_s
    data = user.temp_current_data

    index = data.index(key, user.temp_highlight_start)
    if index.nil?
      user.temp_highlight_start = 0
      user.temp_highlight_length = 0
      :failure
    else
      user.temp_highlight_start = index
      user.temp_highlight_length = key.length
      :success
    end
  end
end
