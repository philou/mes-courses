# Copyright (C) 2014 by Philippe Bourgau



t = Thread.new do
  puts "do you want to start this stuff ?"
  c = gets
  if c.strip == 'y'
    10.times do
      puts "."
      sleep(0.25)
    end
  end
end
t.join
