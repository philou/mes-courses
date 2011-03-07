class HelloWorldController < ApplicationController
  def up
  end

  def down
    raise ArgumentError.new("What the hell do you think down view should be ?")
  end

end
