class CutAction < Action
  Arguments = [
              ]
  Id = 3
  Name = "Cut"

  def self.do_describe(args)
    Name
  end

  def self.do_process(user_state, args)
    data = user_state.temp_current_data

    if user_state.last_mark_position <= 0
      raise "Cannot cut; no mark selected"
    else
    
      data = data[0...user_state.temp_highlight_start] + data[user_state.temp_highlight_start + user_state.temp_highlight_length..-1]
      user_state.temp_current_data = data
    end
  end
end

