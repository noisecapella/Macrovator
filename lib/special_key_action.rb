class SpecialKeyAction < Action
  Arguments = [
               {:key => "type", :default => :down, :optional => false}
              ]
  Id = 4
  Name = "SpecialKey"

  def self.do_describe(args)
    "Keypress " + args.first.value.to_s
  end
  
  def self.do_process(user_state, args)
    key_type = args.first.value.to_sym
    data = user_state.temp_current_data
    current_position = user_state.current_position
    
    if key_type == :down or key_type == :up
      previous_newline_index = (data.rindex("\n", current_position) or 0)
      position_in_line = current_position - previous_newline_index

      rindex = previous_newline_index == 0 ? 0 : data.rindex("\n", previous_newline_index - 1)
      next_newline_index = key_type == :down ? data.index("\n", previous_newline_index + 1) : rindex

      if next_newline_index.nil?
        raise "Cannot go " + key_type.to_s + " from here"
      else
        user_state.current_position = next_newline_index + position_in_line
      end
    elsif key_type == :left or key_type == :right
      inc = key_type == :left ? -1 : 1
      user_state.current_position += inc
    elsif key_type == :delete
      if user_state.current_position + 1 >= data.length
        raise "Nothing left to delete"
      else
        # insert won't work here because it needs to be a different
        # string object to have ActiveRecord save it
        data = data[0...user_state.current_position] + data[user_state.current_position + 1..-1]
        if user_state.temp_highlight_length > 0 and user_state.temp_highlight_start >= user_state.current_position
          user_state.temp_highlight_start -= 1
        end
      end
    elsif key_type == :backspace
      if user_state.current_position == 0
        raise "Nothing to backspace through"
      else
        data = data[0...user_state.current_position - 1] + data[user_state.current_position..-1]
        if user_state.temp_highlight_length > 0 and user_state.temp_highlight_start >= user_state.current_position
          user_state.temp_highlight_start -= 1
        end
      end
    elsif key_type == :enter
      data = data[0...user_state.current_position] + "\n" + data[user_state.current_position..-1]
      if user_state.temp_highlight_length > 0 and user_state.temp_highlight_start >= user_state.current_position
        user_state.temp_highlight_start += 1
      end
    end

    if user_state.current_position < 0
      user_state.current_position = 0
      raise "Went too far to left"
    elsif user_state.current_position >= user_state.temp_current_data.length
      user_state.current_position = user_state.temp_current_data.length - 1
      raise "Went too far to right"
    end

    user_state.temp_current_data = data
  end

  def self.create(key_number, action_list)
    print "CREATE SPECIAL KEY"
    action_type = ActionType.new
    action_type.action_list = action_list
    action_type.action_type = Id
    argument = Argument.new
    argument_schema = Arguments.first
    argument.key = argument_schema[:key]
    argument.value = case key_number
                     when 37
                       :left
                     when 38
                       :up
                     when 39
                       :right
                     when 40
                       :down
                     when 8
                       :backspace
                     when 13
                       :enter
                     when 46
                       :delete
                     end
    action_type.arguments << argument
    if argument.value.nil?
      nil
    else
      action_type
    end
  end
end
