class Tagger
  InsertionPoint = Struct.new :str, :pos, :is_html_safe, :distance_from_start_tag

  def initialize(content)
    @content = content
    @insertions = []
  end

  def add_tags(str, pos, end_str, end_pos)
    start_tag = InsertionPoint.new(str, pos, true, nil)
    end_tag = InsertionPoint.new(end_str, end_pos, true, end_pos - start_tag.pos)

    @insertions << start_tag
    @insertions << end_tag
  end

  def add_global_replace(from, to, is_html_safe = true)
    @content.to_enum(:scan, from).map do |m,|
      index = $`.size
      s = InsertionPoint.new(to, index, is_html_safe, nil)
      
      @insertions << s
    end
  end

  def display_content
    sorted_insertions = @insertions.sort { |a, b| a.pos <=> b.pos }.reverse

    content = @content.dup

    sorted_insertions.inject(content) do |t, x|
      if x.distance_from_start_tag == 1 and t[x.pos-1...x.pos] == " "
        # preserve space
        t.insert(x.pos, x.str + " ")
      else
        t.insert(x.pos, x.str)
      end
    end.html_safe
    
  end
  
end
