require 'spec_helper'

describe "/item_sub_type/show.html.erb" do
  before(:each) do
    items = ["Bavette", "Entrecôte"].map {|item| stub_model(Item,
                                                            :name => item,
                                                            :price => item.length/100.0,
                                                            :summary => "#{item} extra",
                                                            :image => "http://www.photofabric.com/#{item}")}
    @item_sub_type = ItemSubType.new(:name => "Viande de boeuf", :items => items)
    assigns[:item_sub_type] = @item_sub_type
    render
  end

  it "displays the name of the item sub type" do
    response.should contain(@item_sub_type.name)
  end

  [:name, :price, :summary].each do |attribute|
    it "displays the #{attribute} of its items" do
      @item_sub_type.items.each do |item|
        response.should contain(item.send(attribute).to_s)
      end
    end
  end

  it "displays a link to add each of its items to the cart" do
    @item_sub_type.items.each do |item|
      response.should have_selector("a", :href => default_path(:controller => 'cart',
                                                               :action => 'add_item_to_cart',
                                                               :id => item.id))
    end
  end

  it "displays the image of its items" do
    @item_sub_type.items.each do |item|
      response.should have_selector("img", :src => item.image)
    end
  end

end
