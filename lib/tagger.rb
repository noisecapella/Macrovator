class Tagger
  Tag = Struct.new :start_tag_str, :end_tag_str, :start_pos, :end_pos

  def initialize(content)
    @content = content
    @insertions = {}
    @replace_spaces_with_tags = false
  end

  def add_insertion(pos, tag)
    if not @insertions.include? pos
      @insertions[pos] = [tag]
    else
      @insertions[pos] << tag
    end
  end

  def add_tags(str, pos, end_str, end_pos)
    tag = Tag.new(str, end_str, pos, end_pos)

    add_insertion(pos, tag)
    add_insertion(end_pos, tag)
  end

  def add_global_replace(from, to, is_html_safe = true)
    @content.to_enum(:scan, from).map do |m,|
      index = $`.size
      s = InsertionPoint.new(to, index, is_html_safe, nil)
      
      @insertions << s
    end
  end

  def replace_spaces_with_tags
    @replace_spaces_with_tags = true
  end

  def display_content
    ret = "<p>"
    @content.length.times do |i|
      c = @content[i]
      already_wrote_char = false
      if @replace_spaces_with_tags and (c == "\n" or c == " " or c == "\t")
        if c == "\n"
          ret << "<br />"
        else
          ret << " "
        end
        already_wrote_char = true
      end

      if @insertions.include? i
        tag_list = @insertions[i]
        tag_list.each do |tag|
          if tag.start_pos == i
            ret << tag.start_tag_str
          end
        end
      end
      if not already_wrote_char
        ret << c
      end
      if @insertions.include? i
        tag_list = @insertions[i]
        tag_list.each do |tag|
          if tag.end_pos == i
            ret << tag.end_tag_str
          end
        end
      end
    end
    ret << "</p>"
    ret
  end
  
end
