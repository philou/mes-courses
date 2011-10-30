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

  desc "Import stores, by default, (re)import all existing stores, if url=http://... is specified, imports (and maybe creates) this store only. Define STORES_IMPORT_DAY to run a specified day of the week."
  task :import => :environment do
    if Time.now.wday != import_day
      Rails.logger.info "Skipping stores import this day of the week"
      return
    end

    Store.import(ENV['url'])
  end

  private

  def import_day
    ENV['STORES_IMPORT_DAY'].to_i || 0
  end

end
