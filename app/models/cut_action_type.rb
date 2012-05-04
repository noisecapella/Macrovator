class CutActionType < ActionType
  acts_as_citier

  def describe
    "Cut"
  end

  def self.my_name
    "Cut"
  end


  def make_arguments
    []
  end
end
