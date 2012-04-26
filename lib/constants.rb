class Constants

  AllArguments = [SearchAction, CutAction, PasteAction, KeyPressAction, SpecialKeyAction]

  ActionMap = Hash[ AllArguments.map { |arg| [arg::Id, arg] }]
end
