class PasteAction < Action
  Arguments = [
              ]
  Id = 2
  Name = "Paste"

  def self.do_describe(args)
    Name
  end
end
