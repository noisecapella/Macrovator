class BeginActionType < ActionType
  def describe
    "Begin"
  end
  def self.my_name
    "Begin"
  end
  def make_arguments
    []
  end
  def process(user_state)
    # do nothing
  end
end
