class Brightness < Widget
  def update
    perc = (`xrandr --verbose | grep Brightness`.split(':').last.strip.to_f*100).to_i
    piece = perc.to_i/(100/(THEME[:indicator][:vertical].count * 2 - 2))-1
    @text  = "%{F#{THEME[:colors][:lgray]}}%{A5:backlight #{(perc-6)}:}%{A4:backlight #{(perc+6)}:}%{A:backlight #{(perc-6)}:}\uf068%{A} "
    @text += "#{THEME[:indicator][:vertical].map{|x| "#{x}#{x}"}.join.split('').each_with_index.map{|x,i| "%{F#{THEME[:colors][(i <= piece ? :blue : :gray)]}}#{x}%{F-}" }.join} "
    @text += "%{F#{THEME[:colors][:lgray]}}%{A:backlight #{(perc+6)}:}\uf067%{A} #{' 'if perc < 100}#{perc}%{A}%{A} "
  end

  def icon
    "\uf185"
  end
end
