#!/usr/bin/env ruby
Dir[File.dirname(__FILE__) + "/**/*.rb"].each { |f| require f }

trap("SIGINT") { exit 0 }

IO.popen(Lemonbar.cmd, "r+") do |pipe|
  loop do
    $t = Time.now.to_i
    pipe.puts "%{l}#{Widgets.left.render}%{c}#{Widgets.center.render}%{r}#{Widgets.right.render}"
    Input.read(pipe)
  end
end
