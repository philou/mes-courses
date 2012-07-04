# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

class RenameToDeleteItemsToImportSoldOutItems < ActiveRecord::Migration
  def change
    rename_table :to_delete_items, :import_sold_out_items
  end
end
