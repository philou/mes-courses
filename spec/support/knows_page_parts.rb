# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

module KnowsPageParts

  def items_panel
    PagePart.new("//div[@id='items-panel']", "an items panel")
  end

  def item_with_name(name)
    items_panel.with("//tr[td[contains(.,'#{name}')]]", "an item named '#{name}'")
  end

  def disabled_item_with_name(name)
    item_with_name(name).that("[//img[@src='/images/disabled.png'] and //input[@type='submit' and @disabled='disabled']]", "is disabled")
  end

  def enabled_item_with_name(name)
    item_with_name(name).that("[//input[@type='submit' and not(@disabled)]]", "is enabled")
  end

  def dish_with_name(name)
    PagePart.new("//body[@id='dish']//table//tr[td[contains(.,'#{name}')]]", "a dish named #{name}")
  end

  def disabled_dish_with_name(name)
    dish_with_name(name).that("[//input[@type='submit' and @disabled='disabled']]", "is disabled")
  end

  def enabled_dish_with_name(name)
    dish_with_name(name).that("[//input[@type='submit' and not(@disabled)]]", "is enabled")
  end

end
