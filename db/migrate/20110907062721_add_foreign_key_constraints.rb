# -*- encoding: utf-8 -*-
# Copyright (C) 2011 by Philippe Bourgau

class AddForeignKeyConstraints < ActiveRecord::Migration

  FOREIGN_KEYS = [[:cart_lines, :carts],
                  [:dishes_items, :dishes],
                  [:dishes_items, :items],
                  [:item_categories, :item_categories, { :column => :parent_id, :dependent => :destroy, :name => :item_categories_parent_id_fk } ],
                  [:items, :item_categories],
                  [:orders, :carts],
                  [:orders, :stores]]

  def self.up
    FOREIGN_KEYS.each do |fk_args|
      add_foreign_key *fk_args
    end
  end

  def self.down
    FOREIGN_KEYS.each do |fk_args|
      table = fk_args[0]
      foreign_keys(table).each do |fk_def|
        remove_foreign_key table, :name => fk_def.options[:name]
      end
    end
  end
end
