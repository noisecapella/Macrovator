class Constants

  AllArguments = [SearchAction, CutAction, PasteAction]

  ActionMap = Hash[ AllArguments.map { |arg| [arg::Id, arg] }]
end
