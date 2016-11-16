class Battery < Widget
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
    @text = "%{A:battery_popup:}#{@text}%{A}"
  end

  def action_battery_popup cmd
    Popup.new("Battery", 36, {
        "State" => "#{@data["state"] == 'discharging' ? "^fg(#{Theme.get(:gold)})" : "^fg(#{Theme.get(:green)})"}#{@data["state"]}",
        "Warn level" => "#{"^fg(#{Theme.get(:red)})" if @data['warning-level'] != 'none'}#{@data['warning-level']}",
        "Energy" => "#{@data['energy']} / #{@data['energy-full']}",
        "Energy rate" => "#{@data['energy-rate']}, #{@data['voltage']}",
        "Time left" => "#{@data['time to empty']}",
        "Percentage" => "#{@data['percentage'].to_i < 50 ? "^fg(#{Theme.get(:gold)})" : "^fg(#{Theme.get(:green)})"}#{@data['percentage']}",
        "Capacity" => "#{@data['capacity']}"
    }).exec(10, 354)
  end

  private

  def load perc
    perc = perc.to_i
    step = 100/BATTERY_INDICATOR.count
    color = :green
    color = :gold if perc < 51
    color = :red if perc < 20
    color = :blue if perc >= 99
    "%{F#{Theme.get_argb(color)}}#{BATTERY_INDICATOR[(perc/step).to_i]}%{F-}"
  end

  def symbol state, perc
     s = 2; color = :blue;
    (s = 0; color = :gold) if state == 'discharging'
    (s = 0; color = :red) if state == 'discharging' && perc.to_i < 20
    (s = 1; color = :green)  if state == 'charging'
    "%{F#{Theme.get_argb(color)}}#{@symbols[s]}%{F-}"
  end
end
