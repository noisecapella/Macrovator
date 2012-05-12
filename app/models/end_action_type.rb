class EndActionType < ActionType
  def describe
    "End"
  end
  def self.my_name
    "End"
  end
  def make_arguments
    []
  end
  def process(user_state)
    # do nothing
  end
end
