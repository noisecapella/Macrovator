class Action
  public
  def self.id
    self::Id
  end
  def self.my_name
    self::Name
  end

  def self.verify_args(args)
    assert(self::Arguments.length, args.length, "Number of arguments")
    0.until(self::Arguments.length) do |i|
      expected_arg = self::Arguments[i]
      actual_arg = args[i]
      assert(expected_arg.key, actual_arg.key, "Arg " + i.to_s)
    end
    
  end

  def self.assert(expected, actual, what = "Something")
    if expected != actual
      raise what.to_s.capitalize + " should be " + expected.to_s + " but was " + actual.to_s
    end
  end
  def self.describe(args)
    verify_args(args)
    self.do_describe(args)
  end

  def self.process(user_state, args)
    self.do_process(user_state, args)
  end

  private
  ArgumentSpec = Struct.new :key, :default, :optional
end
