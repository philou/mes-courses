#!/usr/bin/env ruby

if ARGV.count == 0 or ["-h","--help"].include?(ARGV[0])
  puts "Command line spike, parses a repo argument"
  puts
  puts "  Usage: cmd_line.rb REPO"
  puts
else
  repo = ARGV[0]

  puts "repo=" + repo
end

