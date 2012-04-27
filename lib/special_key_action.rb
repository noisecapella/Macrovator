class SpecialKeyAction < Action
  Arguments = [
               ArgumentSpec.new("type", :down, false)
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
    
    case key_type
    when :up
      current_newline_index = data.rindex("\n", current_position)
      if current_newline_index.nil? or current_newline_index == 0
        # top line of file
        raise "Cannot go up from here"
      end

      previous_newline_index = data.rindex("\n", current_newline_index - 1)
      if previous_newline_index.nil?
        # next to top line in file
        previous_newline_index = -1
      end
      
      current_position_in_line = current_position - (current_newline_index + 1)
      
      up_position = current_position_in_line + (previous_newline_index + 1)

      user_state.current_position = up_position
    when :down
      current_newline_index = data.rindex("\n", current_position)
      if current_newline_index.nil?
        # top line of file
        current_newline_index = -1
      end

      next_newline_index = data.index("\n", current_position)
      if next_newline_index.nil?
        # bottom line of file
        raise "Cannot go down from here"
      end
      
      current_position_in_line = current_position - (current_newline_index + 1)
      
      down_position = current_position_in_line + (next_newline_index + 1)
      if down_position >= data.length
        down_position = data.length - 1
      end
      
      user_state.current_position = down_position
      
      
    when :left
      user_state.current_position -= 1
    when :right
      user_state.current_position += 1
    when :delete
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
    when :backspace
      if user_state.current_position == 0
        raise "Nothing to backspace through"
      else
        data = data[0...user_state.current_position - 1] + data[user_state.current_position..-1]
        if user_state.temp_highlight_length > 0 and user_state.temp_highlight_start >= user_state.current_position
          user_state.temp_highlight_start -= 1
        end
        user_state.current_position -= 1
      end
    when :enter
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
    action_type = ActionType.new
    action_type.action_list = action_list
    action_type.action_type = Id
    argument = Argument.new
    argument_schema = Arguments.first
    argument.key = argument_schema.key
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
