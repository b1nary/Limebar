class RAM < Widget
  def initialize options = {}
    @indicator = options[:indicator] || :vertical
    @format = options[:format] || "$percentage $indicator"
    super(options)
    update
  end

  def update
    @all, @used, @free = `free`.split("\n")[1].split(' ').map(&:to_i)[1..3]
    used_perc = @used/(@all/100)
    @text = @format.gsub('$percentage', "#{used_perc.to_i}%")
                   .gsub('$indicator', load(used_perc))
    @text = "%{A:#{Popup.command(popup, @offset, 6, 214)}:}#{@text}%{A}"
  end

  def popup
    blue = "^fg(##{THEME[:colors][:blue][3..8]})"
    orange = "^fg(##{THEME[:colors][:orange][3..8]})"
    green = "^fg(##{THEME[:colors][:green][3..8]})"
    red = "^fg(##{THEME[:colors][:red][3..8]})"
    used_perc = @used/(@all/100)
    Popup.new("RAM", 20, {
        "Used" => "#{if used_perc > 80; red; elsif used_perc > 50; orange; else; green; end}#{'%.2f' % (@used/1024/1024.0)} GB (#{used_perc.to_i}%)",
        "Free" => "#{'%.2f' % (@free/1024/1024.0)} GB",
        "All" => "#{'%.2f' % (@all/1024/1024.0)} GB"
    }).render
  end

  private

  def load perc
    ind = THEME[:indicator][@indicator]
    ind = ind[(perc/ind.size).to_i]
    color = THEME[:colors][:green]
    color = THEME[:colors][:orange] if perc > 50
    color = THEME[:colors][:red] if perc > 80
    "%{F#{color}}#{ind}%{F-}"
  end
end
