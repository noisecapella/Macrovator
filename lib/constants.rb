class Constants

  AllArguments = [SearchAction, CutAction, PasteAction, KeyPressAction, DirectionKeyAction]

  ActionMap = Hash[ AllArguments.map { |arg| [arg::Id, arg] }]
end
