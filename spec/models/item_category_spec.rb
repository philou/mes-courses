# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe ItemCategory do

  it "should have items" do
    category = ItemCategory.new(:name => "Boeuf")
    category.items.should_not be_nil
  end

end
