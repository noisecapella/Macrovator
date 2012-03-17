class CutAction < Action
  Arguments = [
              ]
  Id = 3
  Name = "Cut"

  def self.do_describe(args)
    Name
  end
end

