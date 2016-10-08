class FancyBattery < Widget
  COMMAND = "upower -i /org/freedesktop/UPower/devices/battery_BAT0"

  def initialize options = {}
    @symbols = options[:symbols] || ["▼", "▲", "✿"]
    @indicator = options[:indicator] || :vertical
    @format = options[:format] || "$symbol $percentage $indicator"
    super(options)
  end

  def update
    @data = `#{COMMAND}`.split("\n").map {|l| l.split(':  ').map(&:strip)}.reject{|arr| arr.length != 2}.to_h
    @text = @format.gsub("$symbol", symbol(@data['state'], @data['percentage']))
                   .gsub('$percentage', @data['percentage'])
                   .gsub('$indicator', load(@data['percentage']))
    @text = "%{A:#{Popup.command(popup, @offset, 10, 354)}:}#{@text}%{A}"
  end

  def popup
    blue = "^fg(##{THEME[:colors][:blue][3..8]})"
    orange = "^fg(##{THEME[:colors][:orange][3..8]})"
    green = "^fg(##{THEME[:colors][:green][3..8]})"
    red = "^fg(##{THEME[:colors][:red][3..8]})"
    Popup.new("Battery", 36, {
        "State" => "#{@data["state"] == 'discharging' ? orange : green}#{@data["state"]}",
        "Warn level" => "#{red if @data['warning-level'] != 'none'}#{@data['warning-level']}",
        "Energy" => "#{@data['energy']} / #{@data['energy-full']}",
        "Energy rate" => "#{@data['energy-rate']}, #{@data['voltage']}",
        "Time left" => "#{@data['time to empty']}",
        "Percentage" => "#{@data['percentage'].to_i < 50 ? orange : green}#{@data['percentage']}",
        "Capacity" => "#{@data['capacity']}"
    }).render
  end

  private

  def load perc
    perc = perc.to_i
    step = 100/THEME[:indicator][@indicator].count
    color = :green
    color = :orange if perc < 51
    color = :red if perc < 20
    color = :blue if perc >= 99
    "%{F#{THEME[:colors][color]}}#{THEME[:indicator][@indicator][(perc/step).to_i]}%{F-}"
  end

  def symbol state, perc
     s = 2; color = THEME[:colors][:blue];
    (s = 0; color = THEME[:colors][:orange]) if state == 'discharging'
    (s = 0; color = THEME[:colors][:red]) if state == 'discharging' && perc.to_i < 20
    (s = 1; color = THEME[:colors][:green])  if state == 'charging'
    "%{F#{color}}#{@symbols[s]}%{F-}"
  end
end
