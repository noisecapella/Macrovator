class SpecialKeyAction < Action
  Arguments = [
               {:key => "direction", :default => :down, :optional => false}
              ]
  Id = 4
  Name = "DirectionKey"

  def self.do_describe(args)
    "Keypress " + args.first.value.to_s
  end
  
  def self.do_process(user_state, args)
    direction = args.first.value.to_sym
    data = user_state.temp_current_data
    current_position = user_state.current_position
    
    if direction == :down or direction == :up
      previous_newline_index = (data.rindex("\n", current_position) or 0)
      position_in_line = current_position - previous_newline_index

      rindex = previous_newline_index == 0 ? 0 : data.rindex("\n", previous_newline_index - 1)
      next_newline_index = direction == :down ? data.index("\n", previous_newline_index + 1) : rindex

      if next_newline_index.nil?
        raise "Cannot go " + direction.to_s + " from here"
      else
        user_state.current_position = next_newline_index + position_in_line
      end
    else
      inc = direction == :left ? -1 : 1
      user_state.current_position += inc
    end

    if user_state.current_position < 0
      user_state.current_position = 0
      raise "Went too far to left"
    elsif user_state.current_position >= user_state.temp_current_data.length
      user_state.current_position = user_state.temp_current_data.length - 1
      raise "Went too far to right"
    end
  end

  def self.create(key_number, action_list)
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
                     end
    action_type.arguments << argument
    if argument.value.nil?
      nil
    else
      action_type
    end
  end
end
