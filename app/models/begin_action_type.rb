class BeginActionType < ActionType
  acts_as_citier

  def describe
    "Begin"
  end
  def self.my_name
    "Begin"
  end
  def make_arguments
    []
  end
end
