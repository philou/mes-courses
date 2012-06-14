# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

class Cucumber::Ast::Table
  def each_item
    hashes.each do |row|
      yield row["Category"], row["Sub category"], row["Item"]
    end
  end
end
