# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

require "mes_courses/initializers/enumerator_lazy"

describe Enumerator::Lazy, '#flatten' do

  it "returns the same collection as stock flatten" do
    tree = [[1], [1,2], [1,[2,3]]]
    tree.lazy.flatten.to_a.should == tree.flatten
    tree.lazy.flatten(1).to_a.should == tree.flatten(1)
    tree.lazy.flatten(0).to_a.should == tree.flatten(0)
  end

  it "processes items on demand" do
    processed_items = 0
    enums = (1..3).lazy.map {|i| (1..i).lazy.map {|j| processed_items += 1; j}}

    enums.flatten.first(3).should == [1, 1,2]
    processed_items.should == 3
  end

  it "returns empty list for empty list" do
    [].lazy.flatten.to_a.should == []
  end
end
