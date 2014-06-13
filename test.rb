# Copyright (C) 2014 by Philippe Bourgau


module Bar
  def speak
    puts "Bar speaking"
  end
end

module Baz
  include Bar
  def tell
    puts "Baz speaking"
  end
end

class Foo
  include Baz
end

Foo.new.tell
Foo.new.speak

