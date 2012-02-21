# Copyright (C) 2012 by Philippe Bourgau

class AddSponsoredLinkToStore < ActiveRecord::Migration
  def self.up
    add_column :stores, :sponsored_url, :string
    execute "UPDATE stores set sponsored_url = url"
    execute "UPDATE stores set sponsored_url = 'http://clic.reussissonsensemble.fr/click.asp?ref=574846&site=8005&type=text&tnb=2' where url = 'http://www.auchandirect.fr'"
    change_column :stores, :sponsored_url, :string, :null => false
  end

  def self.down
    remove_column :stores, :sponsored_url
  end
end
