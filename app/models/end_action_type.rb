class EndActionType < ActionType
  acts_as_citier

  def describe
    "End"
  end
  def self.my_name
    "End"
  end
  def make_arguments
    []
  end
end
