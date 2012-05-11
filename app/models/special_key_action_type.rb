class SpecialKeyActionType < ActionType
  acts_as_citier

  KeytypeMap = {40 => :down, 
    38 => :up,
    37 => :left,
    39 => :right,
    8 => :backspace,
    13 => :enter,
    46 => :delete}

  attr_accessible :keytype

  validates :keytype, :inclusion => {:in => KeytypeMap.keys}

  def describe
    keypress_string = KeytypeMap[self.keytype].to_s
    "Keypress #{keypress_string}"
  end

  def process(user_state)
    key_type = KeytypeMap[self.keytype]
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
      user_state.current_position += 1
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

  def self.my_name
    "SpecialKey"
  end

  def make_arguments
    #TODO: improve this
    [
     Argument.new("keytype", "Special key", self.keytype || 40)
    ]
  end

end
