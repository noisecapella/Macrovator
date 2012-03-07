class SearchAction < Action
  Arguments = [
               {:key => "term", :default => "", :optional => false}
              ]
  Id = 1
  Name = "Search"
end
