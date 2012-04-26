class Tagger
  InsertionPoint = Struct.new :str, :pos, :is_html_safe, :h

  def initialize(content)
    @content = content
    @insertions = []
  end

  def add(str, pos, is_html_safe)
    s = InsertionPoint.new(str, pos, is_html_safe)

    @insertions << s
  end

  def add_global_replace(from, to, is_html_safe)
    @content.to_enum(:scan, from).map do |m,|
      index = $`.size
      s = InsertionPoint.new(to, index, is_html_safe)
      
      @insertions << s
    end
  end

  def display_content
    sorted_insertions = @insertions.sort { |a, b| a.pos <=> b.pos }.reverse

    content = @content

    sorted_insertions.inject(content) do |t, x|
      t.insert(x.pos, x.str)
    end.html_safe
    
  end
  
end
