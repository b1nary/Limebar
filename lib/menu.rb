class Menu
  def initialize options
    @cmd = "echo \"#{options.join("\n")}\" | dmenu -fn 'mononoki' -l 3 -w 200 -x 1400 -y 22"
  end

  def render
    `#{@cmd}`
  end
end
