class Widget
  attr_reader :offset

  def initialize options = {}
    @bg   = options[:bg] || nil
    @fg   = options[:fg] || nil
    @text = options[:text] || ""

    @space      = options[:space] || " "
    @max_width  = options[:max_width]
    @width      = options[:width]

    @offset = 0

    update
  end

  def render offset, nobreak = false
    @offset = offset
    update
    body = "#{@space}#{"%{B#{@bg}}" if @bg}#{"%{F#{@fg}}" if @fg}#{@text}#{@space}"
    body = truncate(body, @max_width) if @max_width
    body = fill_up(body, @width) if @width
    "#{body}#{"%{F-}%{B-}" if nobreak == false}"
  end

  def len
    @text.split('}').collect{|x|x.split('%{').first}.join.length
  end

  private

  def update
  end

  def truncate(string, max)
    string.length > max ? "#{string[0...max]}..." : string
  end

  def fill_up(string, length)
    l = self.len
    if l > length
      truncate(string, length-@space.length)+@space
    elsif l < length
      string+(" "*(length-l))
    else
      string
    end
  end
end
