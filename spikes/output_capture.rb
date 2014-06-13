# Copyright (C) 2014 by Philippe Bourgau


require 'stringio'

#module Kernel

  def capturing_outputs
    old_stdout = $stdout
    old_stderr = $stderr

    out = StringIO.new

    $stdout = out
    $stderr = out

    yield

    return result
  ensure
    $stdout = old_stdout
    $stderr = old_stderr
  end

#end


  output = capturing_outputs do

    puts "This is a test"
    $stderr.puts "This is an error"

  end

  puts "-- captured output --"
  puts output


  value = capturing_outputs { puts capturing_outputs { puts "toto" } }

  puts "expected \"toto\", got : #{value.inspect}"
