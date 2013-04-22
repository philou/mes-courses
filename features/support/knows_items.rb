# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

class Cucumber::Ast::Table
  def each_item
    hashes.each do |row|
      yield row["Category"], row["Sub category"], row["Item"]
    end
  end
end

module KnowsItems

  def visit_every_item_in(table)
    table.each_item do |category, sub_category, item|
      visit item_categories_path
      click_link(category)
      click_link(sub_category)
      yield(page, item)
    end
  end

end
World(KnowsItems)
