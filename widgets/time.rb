class TimeDate < Widget
  def update
    @text = "%{B#{Theme.get_argb(:dark_gray)}}%{F#{Theme.get_argb(:green)}}%{B#{Theme.get_argb(:green)}}%{F#{Theme.get(:black)}} #{"%02d" % Time.now.hour}:#{"%02d" % Time.now.min}"
  end
end
