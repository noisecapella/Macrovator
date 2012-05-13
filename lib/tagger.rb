class Tagger
  Tag = Struct.new :start_tag_str, :end_tag_str, :start_pos, :end_pos

  def h(c)
    case c
    when "<"
      "&lt;"
    when ">"
      "&gt;"
    when "&"
      "&amp;"
    else
      c
    end
  end

  def initialize(content)
    @content = content
    @insertions = {}
    @replace_spaces_with_tags = false
  end

  def debug
    @insertions.to_s
  end

  def add_insertion(pos, tag)
    if not @insertions.include? pos
      @insertions[pos] = [tag]
    else
      @insertions[pos] << tag
    end
  end

  def add_tags(str, pos, end_str=nil, end_pos=nil)
    end_pos = end_pos.nil? ? nil : (end_pos - 1)
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

      if @insertions.include? i
        tag_list = @insertions[i]
        tag_list.each do |tag|
          if tag.start_pos == i
            ret << tag.start_tag_str
          end
        end
      end
      if c == "\n"
        ret << "<br />"
      elsif c == " " or c == "\t"
        ret << "&nbsp;"
      else
        ret << h(c)
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
