# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require "dummy_store_generation"

namespace :stores do

  desc "Inserts the www.auchandirect.fr store in the DB"
  task :create_auchan_direct => :environment do
    Store.find_or_create_by_url(MesCourses::Stores::Carts::AuchanDirectApi.url) do |store|
      store.expected_items = 6000
      store.sponsored_url = 'http://clic.reussissonsensemble.fr/click.asp?ref=574846&site=8005&type=text&tnb=2'
    end
  end

  desc "Inserts the www.dummy-store.com store in the DB"
  task :create_dummy_store => :environment do
    Store.find_or_create_by_url(MesCourses::Stores::Carts::DummyApi.url) do |store|
      store.expected_items = 0
      store.sponsored_url = MesCourses::Stores::Carts::DummyApi.url
    end
  end

  desc "Generates a real dummy store and registers it in the DB"
  task :generate_real_dummy_store => :environment do
    generated_store = RealDummyStore.open("by-rake")
    generated_store.generate(3).categories.and(3).categories.and(3).items

    Store.find_or_create_by_url(generated_store.uri) do |store|
      store.sponsored_url = store.url
    end
  end

  desc "Import stores, by default, (re)import all existing stores, if url=http://... is specified, imports (and maybe creates) this store only. Define STORES_IMPORT_DAY to run a specified day of the week."
  task :import => :environment do
    if Time.now.wday != import_day
      Rails.logger.info "Skipping stores import this day of the week"
    else
      Store.import(ENV['url'])
    end
  end

  private

  def import_day
    ENV['STORES_IMPORT_DAY'].to_i || 0
  end

end
