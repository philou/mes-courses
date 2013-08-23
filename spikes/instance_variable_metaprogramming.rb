

klass = Class.new do
  self.send(:define_method, :get_toto) do
    @toto
  end
  self.send(:define_method, :set_toto) do |value|
    @toto = value
  end
end

k = klass.new

k.set_toto("k")
puts k.get_toto

k2 = klass.new
k2.set_toto("k2")
puts k2.get_toto

puts klass.instance_variable_get(:@toto)
puts @toto
