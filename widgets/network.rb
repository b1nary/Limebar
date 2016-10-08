class Network < Widget
  def initialize options = {}
    @connected = true
    @is_wifi   = false
    super options
  end

  def update
    @text = "%{A:select_wifi:}\uf1eb%{A}#{GEO.ip}"
  end

  def icon
    @connected ? (@is_wifi ? "\uf1eb" : "\uf1e6") : "\uf05e"
  end
end
