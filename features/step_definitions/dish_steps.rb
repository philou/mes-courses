Given /^"([^"]*)" is a known dish$/ do |dish_name|
  @known_dish = Dish.create!(:name => dish_name)
end
