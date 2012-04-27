class ModifiedKeyAction < Action
  Arguments = [
               ArgumentSpec.new("key_number", ".", false),
               ArgumentSpec.new("ctrl", false, true),
               ArgumentSpec.new("meta", false, true),
               ArgumentSpec.new("alt", false, true)
              ]
  Id = 6
  Name = "ModifiedKey"

  def self.do_describe(args)
    modifiers = ""
    args[1..-1].each do |arg|
      modifiers += arg.key.to_s + " + "
    end
    modifiers + "'" + args.first.value.to_i.chr + "'"
  end

  def self.do_process(user_state, args)
    key_number = args.first.value.to_i
    data = user_state.temp_current_data
    current_position = user_state.current_position

    #TODO: do something
  end

  def self.create(key_number, keys, action_list)
    action_type = ActionType.new
    action_type.action_list = action_list
    action_type.action_type = Id
    argument = Argument.new
    argument_schema = Arguments.first
    argument.key = argument_schema.key
    argument.value = key_number.to_i
    action_type.arguments << argument

    Arguments[1..-1].each do |argument_schema|
      if keys.include?(argument_schema.key)
        argument = Argument.new
        argument.key = argument_schema.key
        argument.value = true
        action_type.arguments << argument
      end
    end
    
    action_type
  end
end
