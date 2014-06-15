# Copyright (C) 2014 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.



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
