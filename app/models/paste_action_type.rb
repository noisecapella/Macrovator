class PasteActionType < ActionType
  acts_as_citier

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
