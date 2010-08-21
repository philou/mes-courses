Given /^"([^ ]*) au ([^"]*)" is a known dish$/ do |item1, item2|
  @known_dish = Dish.create!(:name => item1+" au "+item2,
                             :items => [item1,item2].map {|item| Item.create!(:name => item) })
end
