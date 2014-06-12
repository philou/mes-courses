# -*- encoding: utf-8 -*-
# Copyright (C) 2013, 2014 by Philippe Bourgau

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
