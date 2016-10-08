class Volume < Widget
  def update
    perc = `amixer get Master`.split('[')[1].split(']').first
    piece = perc.to_i/(100/(THEME[:indicator][:vertical].count * 2 - 2))-1
    @text  = "%{F#{THEME[:colors][:lgray]}}%{A5:volume -:}%{A4:volume +:}%{A:volume -:}\uf068%{A} "
    @text += "#{THEME[:indicator][:vertical].map{|x| "#{x}#{x}"}.join.split('').each_with_index.map{|x,i| "%{F#{THEME[:colors][(i <= piece ? :green : :gray)]}}#{x}%{F-}" }.join} "
    @text += "%{F#{THEME[:colors][:lgray]}}%{A:volume +:}\uf067%{A} #{' 'if perc != '100%'}#{perc}%{A}%{A}"
  end

  def icon
    "\uf028"
  end
end
