class Lemonbar
  def self.cmd
    "lemonbar -a #{CLICKABLE_AREAS} -F '#{Theme.get_argb(:foreground)}' -B '#{Theme.get_argb(:background)}'#{FONTS.map{|f| " -f '#{f}'"}.join}"
  end
end
