class Tray < Widget
  attr_accessor :widgets

  def initialize options = {}
    @widgets = []
    @active = -1
    @info = Info.new
    super options
  end

  def add widget
    @widgets << widget
    @active = icon if @active.nil?
  end

  def set active
    _new = active.chomp.to_i
    if @active == _new
      @active = -1
    else
      @active = _new
    end
  end

  def update
    @text = "#{@widgets[@active].render(-1) if @active != -1}"
    @text += "%{F#FF424242}%{F-}%{B#FF424242} #{@widgets.each_with_index.map {|k,i|
      "%{A:tabs #{i}:}#{"%{F#{THEME[:colors][:gray]}}" if i != @active}#{k.icon}#{" " if i != @widgets.length-1}%{F-}%{A}"}.join
    }"
    @text += @info.render(-1, true)
  end
end
