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

  def each_item_quantity_and_name
    if column_names.size == 1
      raw.each do |item_name|
        yield 1, item_name.first
      end
    else
      hashes.each do |hash|
        yield hash[:quantities].to_i, hash[:name]
      end
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
