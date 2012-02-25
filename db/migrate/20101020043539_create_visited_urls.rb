# -*- encoding: utf-8 -*-
# Copyright (C) 2010 by Philippe Bourgau

# Marker for urls already visited during import. Allows
# to resume the import after an error
class CreateVisitedUrls < ActiveRecord::Migration
  def self.up
    create_table :visited_urls do |t|
      t.string :url
    end
  end

  def self.down
    drop_table :visited_urls
  end
end
