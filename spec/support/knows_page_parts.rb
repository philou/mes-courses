# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

module KnowsPageParts

  def items_panel
    PagePart.new("an items panel", "//div[@id='items-panel']")
  end

  def item_with_name(name)
    items_panel.with("an item named '#{name}'", "//tr[td[contains(.,'#{name}')]]")
  end

  def disabled_item_with_name(name)
    item_with_name(name).that("is disabled", "[//img[@src='/images/disabled.png'] and //input[@type='submit' and @disabled='disabled']]")
  end

  def enabled_item_with_name(name)
    item_with_name(name).that("is enabled", "[//input[@type='submit' and not(@disabled)]]")
  end

  def dish_with_name(name)
    PagePart.new("a dish named #{name}", "//table[@id='dish-panel']//tr[td[contains(.,'#{name}')]]")
  end

  def disabled_dish_with_name(name)
    dish_with_name(name).that("is disabled", "[//input[@type='submit' and @disabled='disabled' and @value]]")
  end

  def enabled_dish_with_name(name)
    dish_with_name(name).that("is enabled", "[//input[@type='submit' and not(@disabled)]]")
  end

end
