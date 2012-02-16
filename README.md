## Macrovator
A web tool to make it easier to massage and clean raw data text.

Note: There is no working code yet

# Basic ideas
This will be a Ruby on Rails project where people can submit a sample of data and create or select transformations which will produce output which is friendly to their needs.

The name comes from macros in Emacs, which are also pretty neat ways of manipulating text. I use them all the time. However, they aren't as easy as they should be to edit, and they aren't easily shared or reused with other pieces of data.

The main idea is that these transformations should be easily tweaked and reordered. The transformation list should be recorded and reusable with other pieces of data (maybe even producing code which would operate on a larger set of data.)

Some ideas so far:
* parse from XML, JSON, or CSV, or start raw. In the beginning maybe only raw and CSV.
* fuzzy joins based on Levenshtein distance
* simple markers and cut/paste functionality
* the ability to step through the transformation one step at a time
* regex support





