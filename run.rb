#!/usr/bin/env ruby
require 'timeout'
Dir[File.dirname(__FILE__) + "/lib/*.rb"].each { |f| require f }
Dir[File.dirname(__FILE__) + "/widgets/*.rb"].each { |f| require f }

IP_API_URL = "http://icanhazip.com"
TIMEZONEDB_API_KEY = 'YRGR35JML873'

THEME = {
  fg: "#FFF1F1F1",
  bg: "#FF222222",

  font: 'mononoki',

  indicator: {
    vertical: ["","▁","▂","▃","▄","▅","▆","▇","█"],
    horizontal: ["","▏","▎","▍","▌","▋","▊","▉","█"],
    shade: ["","░", "▒", "▓", "█"],
    battery: ["\uf244","\uf243","\uf242","\uf241","\uf240"],
    check: ["✓","✕"],
    check_bold: ["✔","✖"]
  },
  menu: {
    bg: "#222222",
    fg: "#f1f1f1",
    title: "#b0f776",
  },
  colors: {
    blue: "#FF4F9BE2",
    green: "#FFA7E24F",
    orange: "#FFE2B44F",
    red: "#FFE24F4F",
    purple: "#FFC04FE2",
    gray: "#FF888888",
    lgray: "#FFcccccc"
  }
}

@widgets = {left:[],center:[],right:[]}
@widgets[:left] << OpenboxWorkspace.new
@widgets[:left] << FancyBattery.new(indicator: :battery, format: "$symbol $indicator $percentage")
@widgets[:left] << RAM.new(format: "$indicator $percentage")
@widgets[:center] << Volume.new

tabs = Tray.new
tabs.add Volume.new
tabs.add Brightness.new
tabs.add Network.new
#tabs.add "\uf1eb", RAM.new
#tabs.add "\uf05e", RAM.new
@widgets[:right] << tabs

trap("SIGINT") { exit 0 } # Allow ctrl-c

def readpipe(pipe)
  Timeout::timeout 5 do
    cmd = pipe.gets
    if cmd[0..3] == "tabs"
      tabs = @widgets.to_a.flatten.select {|w| w.class.to_s == 'Tray'}.first
      tabs.set cmd.split('tabs ').last
    elsif cmd[0..5] == "volume"
      `amixer -D pulse sset Master 6%#{cmd.split(' ').last}`
    elsif cmd[0..8] == "backlight"
      `xrandr --output LVDS1 --brightness #{cmd.split(' ').last.to_f/100}`
    elsif cmd.chomp == 'select_wifi'
      Menu.new(["A","B","C"]).render
    else
      #puts cmd
      `#{cmd.gsub('\n',"\n")}`
    end
  end
rescue Exception => e
end

IO.popen("lemonbar -a 20 -F '#{THEME[:fg]}' -B '#{THEME[:bg]}' -f '#{THEME[:font]}' -f 'Droid Sans.10' -f 'FontAwesome-12'", "r+") do |pipe|
  loop do
    offset = 0
    pipe.puts @widgets.map{ |k,widgets|
      r = widgets.map { |w| r = w.render(offset); offset += w.len; r }.join
      "#{if k == :left;"%{l}"elsif k == :center;"%{c}";else;"%{r}";end}#{r}"
    }.join
    readpipe(pipe)
    #pipe.puts "%{l}#{left.call} %{c}#{center.call} %{r}#{right.call}"
    #sleep period
  end
end
