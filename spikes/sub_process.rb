# Copyright (C) 2014 by Philippe Bourgau


rout, wout = IO.pipe

# IO.popen(["ruby", "sub_process_ex.rb", {STDERR => STDOUT}]) do |subprocess|
pid = Process.spawn("ruby sub_process_ex.rb", :out => wout, :err => wout)
_, status = Process.wait2(pid)
wout.close
lines = rout.readlines

puts "Subprocess exited with status #{status}, output was :#{lines.join("\n")}"

# IO.popen(["ruby", "sub_process_ex.rb", {STDERR => STDOUT}]) do |subprocess|

