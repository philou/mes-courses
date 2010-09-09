require 'spec_helper'

describe "/item_sub_type/show.html.erb" do
  before(:each) do
    items = ["Bavette", "Entrecôte"].map {|item| stub_model(Item, :name => item)}
    @item_sub_type = ItemSubType.new(:name => "Viande de boeuf", :items => items)
    assigns[:item_sub_type] = @item_sub_type
    render
  end

  it "displays the name of the item sub type" do
    response.should contain(@item_sub_type.name)
  end

  it "displays the names of its items" do
    @item_sub_type.items.each do |item|
      response.should contain(item.name)
    end
  end

  it "displays a link to add each of its items to the cart" do
    @item_sub_type.items.each do |item|
      response.should have_selector("a", :href => default_path(:controller => 'cart',
                                                               :action => 'add_item_to_cart',
                                                               :id => item.id))
    end
  end

end
