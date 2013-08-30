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

  def hashes_with_defaults(main_column, defaults = {})
    hashes_with_default_column(main_column).map do |hash|
      defaults.merge(hash)
    end
  end

  def hash_2_lists
    result = {}
    raw.each do |row|
      raise StandardError.new("hash_2_lists tables must have a '=>' in the second column") unless row.size == 1 or row[1] == '=>'

      result[row[0]] = row.drop(2).reject &:empty?
    end
    result
  end

  private

  def downcase_keys(hash)
    attributes = {}
    hash.each do |k, v|
      attributes[k.downcase] = v
    end
    attributes
  end

  def hashes_with_default_column(main_column)
    if column_names.size == 1
      raw.map do |row|
        { main_column => row.first }
      end
    else
      hashes
    end
  end

end

module KnowsCucumberTables
  def cucumber_table(single_value)
    Cucumber::Ast::Table.new([[single_value]])
  end
end

World(KnowsCucumberTables)
