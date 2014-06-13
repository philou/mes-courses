# Copyright (C) 2014 by Philippe Bourgau


#!/bin/ruby

def RandSmartPass(size = 6)
  c = %w(b c d f g h j k l m n p qu r s t v w x z ch cr fr nd ng nk nt ph pr rd sh sl sp st th tr lt bl)
  v = %w(a e i o u y)
  f, r = false, ''
  (size * 2 + 1).times do
    r << (f ? c[rand * c.size] : v[rand * v.size])
    f = !f
  end
  r
end

10.times do
  puts RandSmartPass(3)
end
