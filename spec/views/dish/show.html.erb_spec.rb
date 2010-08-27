require 'spec_helper'
require 'nulldb_rspec'

describe "/dish/show.html.erb" do
  include NullDB::RSpec::NullifiedDatabase

  before(:each) do
    @dishes = ["Tomates farcies", "Pates au gruyère"].map {|name| stub_model(Dish, :name => name) }
    assigns[:dishes] = @dishes
  end

  it "displays the name of each dish" do
    render
    @dishes.each {|dish| response.should contain(dish.name) }
  end

  it "displays a link to add items to the cart" do
    render
    @dishes.each {|dish| response.should have_selector("a", :href => default_path(:controller => 'cart',
                                                                                  :action => 'add_dish_to_cart',
                                                                                  :id => dish.id)) }
  end

end
