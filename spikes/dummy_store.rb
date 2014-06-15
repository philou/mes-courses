# Copyright (C) 2014 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.



# -*- coding: utf-8 -*-

require "fileutils"

class Array

  def contains?(other)
    other.all? do |x|
      include?(x)
    end
  end

  def stringify
    map &:to_s
  end

end

class Hash

  def contains?(other)
    other.all? do |key, value|
      include?(key) && self[key] == value
    end
  end

  def without(keys)
    reject do |key, value|
      keys.include?(key)
    end
  end

  def stringify_keys
    result = {}
    self.each do |key, value|
      result[key.to_s] = value
    end
    result
  end

end

class RealDummyStore

  def self.open(root_dir, store_name)
    new("#{root_dir}/#{store_name}/index.html", store_name)
  end

  def category(category_name)
    add([category_name], [], {})
    RealDummyStore.new("#{sub_category_dir(category_name)}/index.html", category_name)
  end
  def remove_category(category_name)
    remove([category_name], [], [])
    FileUtils.rm_rf(sub_category_dir(category_name))
  end

  def item(item_name)
    add([], [item_name], {})
    RealDummyStore.new(sub_item_file(item_name), item_name)
  end
  def remove_item(item_name)
    remove([], [item_name], [])
    FileUtils.rm_rf(sub_item_file(item_name))
  end

  def attributes(values)
    add([], [], values.stringify_keys)
  end
  def remove_attributes(*attribute_names)
    remove([], [], attribute_names.stringify)
  end

  private

  def initialize(path, name)
    @path = path
    if !File.exists?(path)
      write(name, [], [], {})
    end
  end

  def sub_category_dir(category_name)
    "#{File.dirname(@path)}/#{category_name}"
  end

  def sub_item_file(item_name)
    "#{File.dirname(@path)}/#{item_name}.html"
  end

  def add(extra_categories, extra_items, extra_attributes)
    name, categories, items, attributes = read

    if !categories.contains?(extra_categories) || !items.contains?(extra_items) || !attributes.contains?(extra_attributes)
      write(name, categories + extra_categories, items + extra_items, attributes.merge(extra_attributes))
    end
  end
  def remove(wrong_categories, wrong_items, wrong_attributes)
    name, categories, items, attributes = read
    write(name, categories - wrong_categories, items - wrong_items, attributes.without(wrong_attributes))
  end

  def write(name, categories, items, attributes)
    FileUtils.mkdir_p(File.dirname(@path))
    IO.write(@path, content(name, categories, items, attributes))
  end

  def content(name, categories, items, attributes)
    (["<!DOCTYPE html>",
     "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /></head>",
     "<body><h1>#{name}</h1><div id=\"categories\"><h2>Categories</h2><ul>"] +
      categories.map {|cat|  "<li><a class=\"category\" href=\"#{cat}/index.html\">#{cat}</a></li>" } +
      ['</ul></div><div id="items"><h2>Items</h2><ul>']+
      items.map      {|item| "<li><a class=\"item\" href=\"#{item}.html\">#{item}</a></li>" } +
      ['</ul></div><div id="attributes"><h2>Attributes</h2><ul>']+
      attributes.map {|key, value| "<li><span id=\"#{key}\">#{value}</span></li>" } +
      ["</ul></div></body></html>"]).join("\n")
  end

  def read
    parse(IO.readlines(@path))
  end

  def parse(lines)
    name = ""
    categories = []
    items = []
    attributes = {}
    lines.each do |line|
      name_match = /<h1>([^<]+)<\/h1>/.match(line)
      sub_match = /<li><a class=\"([^\"]+)\" href=\"[^\"]+.html\">([^<]+)<\/a><\/li>/.match(line)
      attr_match = /<li><span id=\"([^\"]+)\">([^<]+)<\/span><\/li>/.match(line)

      if !!name_match
        name = name_match[1]
      elsif !!sub_match
        case sub_match[1]
        when "category" then categories << sub_match[2]
        when "item" then items << sub_match[2]
        end
      elsif !!attr_match
        attributes[attr_match[1]] = attr_match[2]
      end
    end
    [name, categories, items, attributes]
  end

end


store = RealDummyStore.open("dummy_stores", "www.dummy-store.com")

store.category("Market").tap do |market|
  market.category("Produits congelés")
  market.category("Fruits").item("Bananas").attributes(price: 1.99, summary: "Vas y franky")
  market.category("Vegetables").tap do |vegies|
      vegies.item("Tomatoes").attributes(price: 4.5, summary: "good for health")
      vegies.item("Potatoes").attributes(price: 1.2, summary: "Bargain !")
  end
end

store.category("Market").tap do |market|
  market.remove_category("Fruits")
  market.category("Vegetables").tap do |vegies|
    vegies.remove_item("Tomatoes")
    vegies.item("Potatoes").remove_attributes(:summary)
  end
end

