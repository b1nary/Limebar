class Theme
  def self.theme
    @@raw ||= begin
      theme = File.read("/home/#{`whoami`.chomp}/.Xresources").split("\n").reject { |line|
        line.strip == '' || line[0] == '!'
      }.map{ |line|
        l = line.gsub('*','').gsub('.','').gsub(/\s+/, " ").split(": ");
        [l.first, self.fix_color(l.last)]
      }.to_h

      out = {
        background: theme["background"],
        foreground: theme["foreground"],
        black: theme["color0"],
        dark_gray: theme["color8"],
        red: theme["color1"],
        dark_red: theme["color9"],
        green: theme["color2"],
        dark_green: theme["color10"],
        yellow: theme["color3"],
        gold: theme["color11"],
        blue: theme["color4"],
        dark_blue: theme["color12"],
        magenta: theme["color5"],
        dark_magenta: theme["color13"],
        cyan: theme["color6"],
        dark_cyan: theme["color14"],
        gray: theme["color7"],
        white: theme["color15"]
      }

      out
    end
  end

  def self.get key
    self.theme[key]
  end

  def self.get_argb key, alpha = "FF"
    "##{alpha}#{self.theme[key][1..6]}"
  end

  private

  def self.fix_color color
    color.gsub('/','').gsub('rgb:','')
  end
end
