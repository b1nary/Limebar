class OpenboxWorkspace < Widget
  def initialize options = {}
    @symbols = options[:symbols] || ["▫", "▪"]
    @spacer  = options[:spacer]  || ''
    @workspaces = options[:workspaces] || 4
    super(options)
    update
  end

  def update
    current_workspace = `xprop -root _NET_CURRENT_DESKTOP`.split(' = ').last.strip.to_i
    @text = @workspaces.times.map { |i|
      symbol = (i == current_workspace ? @symbols.last : @symbols.first)
      "%{A:wmctrl -s #{i}:}#{symbol}%{A}"
    }.join(@spacer)
  end
end
