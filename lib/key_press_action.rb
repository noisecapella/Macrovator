class KeyPressAction < Action
  Arguments = [
               {:key => "keynumber", :default => 32, :optional => false}
              ]
  Id = 5
  Name = "KeyPress"

  def self.do_describe(args)
    "Keypress '" + args.first.value.to_s + "'"
  end

  def self.do_process(user_state, args)
    key = args.first.value.chr
    data = user_state.temp_current_data

    # TODO: figure out how to force updating even if we use the same string
    # data = data.insert(user_state.current_position, key)
    user_state.temp_current_data = data[0...user_state.current_position] + key + data[user_state.current_position..-1]
    user_state.current_position += 1
  end

  def self.create(key_number, action_list)
    action_type = ActionType.new
    action_type.action_type = Id
    action_type.action_list = action_list
    argument = Argument.new
    argument_schema = Arguments.first
    argument.key = argument_schema[:key]
    argument.value = key_number.chr
    
    action_type.arguments << argument
    action_type
    
  end
end
