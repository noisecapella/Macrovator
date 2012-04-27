class Action
  public
  def self.id
    self::Id
  end
  def self.my_name
    self::Name
  end

  def self.verify_args(args)
    used_keys = {}
    
    self::Arguments.each do |arg_spec|
      used_keys[arg_spec.key] = arg_spec
    end

    args.each do |arg|
      assert(true, used_keys.include?(arg.key))
      used_keys.delete(arg.key)
    end
    
    used_keys.values.each do |used_key|
      assert(true, used_key.optional)
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
