# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

class Cucumber::Ast::Table
  def each_item
    hashes.each do |row|
      attributes = downcase_keys(row)

      cat = attributes.delete("category")
      sub_cat = attributes.delete("sub category")
      item = attributes.delete("item")

      yield cat, sub_cat, item, attributes
    end
  end

  private
  def downcase_keys(hash)
    attributes = {}
    hash.each do |k, v|
      attributes[k.downcase] = v
    end
    attributes
  end
end

module KnowsItems

  def there_should_be_the_following_items(table)
    visit_every_item_in(table) do |page, item, attributes|
      page.should contain_an(item_with_name(item))
      attributes.each do |name, value|
        item_with_attribute = send("item_with_#{name}", item, value)
        page.should contain_an(item_with_attribute)
      end
    end
  end

  def the_following_items_should_be_in_categories(table)
    visit_every_item_in(table) do |page, item|
      page.should contain_an(item_with_name(item))
    end
  end

  def the_following_items_should_be_disabled(table)
    visit_every_item_in(table) do |page, item|
      page.should contain_a(disabled_item_with_name(item))
    end
  end

  def the_following_items_should_have_been_deleted(table)
    visit_every_item_in(table) do |page, item|
      page.should_not contain_a(item_with_name(item))
    end
  end

  def the_following_items_should_be_enabled(table)
    visit_every_item_in(table) do |page, item|
      page.should contain_an(enabled_item_with_name(item))
    end
  end

  private

  def visit_every_item_in(table)
    table.each_item do |category, sub_category, item, attributes|
      visit item_categories_path
      click_link(category)
      click_link(sub_category)
      yield(page, item, attributes)
    end
  end

end
World(KnowsItems)
