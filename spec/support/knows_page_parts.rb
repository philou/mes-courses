# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

module KnowsPageParts

  def items_panel
    PagePart.new("//div[@id='items-panel']", "an items panel")
  end

  def item_with_name(name)
    items_panel.with("//tr[contains(/td,'#{name}')]", "an item named '#{name}'")
  end

  def disabled_item_with_name(name)
    item_with_name(name).that("[//img[@src='disabled.png']][//input[@type='submit'][@disabled='disabled']]", "is disabled")
  end

end
