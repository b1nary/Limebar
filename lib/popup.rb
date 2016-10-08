class Popup
  def initialize title, len, values
    longest = values.keys.max_by(&:length).length
    @r = ([
      "",
      "  #{title}",
      "  ^fg(#444444)"+("~"*len),
    ] + values.map { |k,v|
      "  ^fg(#{THEME[:menu][:title]})#{fill_up(k, longest)}^fg()#{v}"
    }).join("\\n")
  end

  def render
    @r
  end

  def fill_up k, len
    "#{k}#{" "*((len+2)-k.length)}"
  end

  def self.command text, offset, lines, width
    "echo \"#{text}\" | dzen2 -bg '#{THEME[:menu][:bg]}' -fg '#{THEME[:menu][:fg]}' -x #{offset*10} -ta l -fn #{THEME[:font]} -y 24 -w #{width} -h 20 -l #{lines} -p 5 -e 'onstart=uncollapse;button3=exit;button1=exit'"
  end
end
