class PasteActionType < ActionType
  def describe
    "Paste"
  end
  def self.my_name
    "Paste"
  end

  def make_arguments
    []
  end
end
