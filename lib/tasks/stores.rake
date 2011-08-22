# Copyright (C) 2010, 2011 by Philippe Bourgau

namespace :stores do

  desc "Inserts the www.auchandirect.fr store in the DB"
  task :create_auchan_direct => :environment do
    Store.find_or_create_by_url(AuchanDirectStoreCartAPI.url)
  end

  desc "Inserts the www.dummy-store.com store in the DB"
  task :create_dummy_store => :environment do
    Store.find_or_create_by_url(DummyStoreCartAPI.url)
  end

  desc "Import stores, by default, (re)import all existing stores, if url=http://... is specified, imports (and maybe creates) this store only."
  task :import => :environment do
    if Time.now.wday != 0
      Rails.logger.info "Skipping stores import because today is not sunday"
      return
    end

    ModelStat::update!

    begin
      stores = stores_to_import()
      Rails.logger.info "Importing #{stores.length.to_s} stores"
      stores.each do |store|
        Rails.logger.info "Importing items from #{store.url}"
        store.import
        Rails.logger.info "Done"
      end
    rescue Exception => e
      Rails.logger.fatal "Import unexpectedly stoped with exception #{e.inspect}"
      raise
    end

    ImportReporter.deliver_delta
  end

  private
  # array of stores to import, according to the 'url' environment variable
  def stores_to_import
    if ENV['url'].nil?
      Store.find(:all)
    else
      [Store.find_or_create_by_url(ENV['url'])]
    end
  end

end
