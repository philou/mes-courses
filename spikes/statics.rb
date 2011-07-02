#!/usr/bin/ruby

class C

  def self.new_id
    @counter ||= 0
    @counter += 1
  end

end
