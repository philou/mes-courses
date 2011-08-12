require 'spec_helper'

describe Order do

  it "should assign blank missing items names by default" do
    Order.new.missing_items_names.should == ""
  end

  it "should assign 0 forwarded cart lines count by default" do
    Order.new.forwarded_cart_lines_count.should == 0
  end

end
