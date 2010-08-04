class InsertAuchanDirectStore < ActiveRecord::Migration
  def self.up
    down
    Store.create!(:url => 'http://www.auchandirect.fr')
  end

  def self.down
    Store.delete_all("url = 'http://www.auchandirect.fr'")
  end
end
