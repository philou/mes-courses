# -*- encoding: utf-8 -*-
# Copyright (C) 2012, 2013 by Philippe Bourgau

require_relative "../constants"

class AddSponsoredLinkToStore < ActiveRecord::Migration
  def self.up
    add_column :stores, :sponsored_url, :string
    execute "UPDATE stores set sponsored_url = url"
    execute "UPDATE stores set sponsored_url = '#{DB::Constants::AUCHAN_DIRECT_AFFILINET_URL}' where url = '#{DB::Constants::AUCHAN_DIRECT_URL}'"
    change_column :stores, :sponsored_url, :string, :null => false
  end

  def self.down
    remove_column :stores, :sponsored_url
  end
end
