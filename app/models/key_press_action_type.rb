class KeyPressActionType < ActionType
  acts_as_citier

  attr_accessible :keys

  validates :keys, :presence => true

  def describe
    "Keypress '#{self.keys}'"
  end

  def process(user_state)
    key = self.keys
    data = user_state.temp_current_data

    # TODO: figure out how to force updating even if we use the same string
    # data = data.insert(user_state.current_position, key)
    user_state.temp_current_data = data[0...user_state.current_position] + key + data[user_state.current_position..-1]
    if user_state.temp_highlight_length != 0 and user_state.temp_highlight_start >= user_state.current_position
      user_state.temp_highlight_start += key.length
    end
    user_state.current_position += key.length
  end

  def self.my_name
    "KeyPress"
  end

  def make_arguments
    [
     Argument.new("keys", "Keys", self.keys)
    ]
  end

  
  def is_keypress?
    true
  end
end
