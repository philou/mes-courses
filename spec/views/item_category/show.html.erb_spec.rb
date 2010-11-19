require 'spec_helper'

describe "/item_category/show.html.erb" do

  it "displays the name of the item category" do
    @item_category = stub_model(ItemCategory, :name => "Fruits & Légumes")
    assigns[:item_category] = @item_category
    render

    response.should contain(@item_category.name)
  end

  describe "of a category with children" do
    before(:each) do
      sub_categories = ["Pommes de terre", "Tomates", "Pommes"].map {|category| stub_model(ItemCategory, :name => category)}
      @item_category = stub_model(ItemCategory, :name => "Fruits & Légumes", :children => sub_categories)
      assigns[:item_category] = @item_category
      render
    end

    it "displays the names of its children" do
      @item_category.children.each do |item_category|
        response.should contain(item_category.name)
      end
    end

    it "has a link to each of its children" do
      @item_category.children.each do |item_category|
        response.should have_selector("a", :href => item_category_path(item_category))
      end
    end
  end

  describe "of a category with items" do
    before(:each) do
      items = ["Bavette", "Entrecôte"].map {|item| stub_model(Item,
                                                              :name => item,
                                                              :price => item.length/100.0,
                                                              :summary => "#{item} extra",
                                                              :image => "http://www.photofabric.com/#{item}")}
      @item_category = ItemCategory.new(:name => "Viande de boeuf", :items => items)
      assigns[:item_category] = @item_category
      render
    end

    [:name, :price, :summary].each do |attribute|
      it "displays the #{attribute} of its items" do
        @item_category.items.each do |item|
          response.should contain(item.send(attribute).to_s)
        end
      end
    end

    it "displays a link to add each of its items to the cart" do
      @item_category.items.each do |item|
        response.should have_selector("a", :href => default_path(:controller => 'cart',
                                                                 :action => 'add_item_to_cart',
                                                                 :id => item.id))
      end
    end

    it "displays the image of its items" do
      @item_category.items.each do |item|
        response.should have_selector("img", :src => item.image)
      end
    end
  end
end
