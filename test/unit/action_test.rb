require 'test_helper'

class ActionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "individual ids" do
    assert Constants::AllArguments.length == Constants::ActionMap.keys.length
  end
end
