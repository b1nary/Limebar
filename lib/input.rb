require 'timeout'

class Input
  def self.read pipe
    Timeout::timeout 5 do
      cmd = pipe.gets.chomp
      cmd1 = cmd.split(' ').first.to_sym
      if w = Widgets.all_methods[cmd1]
        w.send("action_#{cmd1}", cmd.split(' ', 2).last.strip)
      else
        `#{cmd.gsub('\n',"\n")}`
      end
    end
  rescue
  end
end
