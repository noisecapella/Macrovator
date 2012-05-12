class WhileNoErrorActionType < ActionType
  def describe
    "Loop while no error"
  end

  def self.my_name
    "WhileNoError"
  end

  def make_arguments
    []
  end

  def process(user_state)
    (user_state.current_action_list_index - 1).downto(0) do |i|
      action_type = action_list.action_types[i]
      if action_type.class == BeginActionType
        user_state.current_action_list_index = i
        return
      end
    end
    raise "No Begin to loop back to"
  end
end
