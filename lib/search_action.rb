class SearchAction < Action
  Arguments = [
               {:key => "term", :default => "", :optional => false}
              ]
  Id = 1
  Name = "Search"

  def self.do_describe(args)
    "Search for '" + args.first.value.to_s + "'"
  end
end
