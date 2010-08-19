require 'spec_helper'

describe "/dish/show.html.erb" do
  before(:each) do
    @dishes = ["Tomates farcies", "Pates au gruyère"].map {|name| stub_model(Dish, :name => name) }
    assigns[:dishes] = @dishes
  end

  it "displays the name of each dish" do
    render
    @dishes.each {|dish| response.should contain(dish.name) }
  end

end
