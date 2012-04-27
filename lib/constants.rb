class Constants

  AllArguments = [SearchAction, CutAction, PasteAction, KeyPressAction, SpecialKeyAction, ModifiedKeyAction]

  ActionMap = Hash[ AllArguments.map { |arg| [arg::Id, arg] }]
end
