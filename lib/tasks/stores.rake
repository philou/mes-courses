namespace :stores do
  desc "Import all existing stores"
  task :import => :environment do
    stores = Store.find(:all)
    Rails.logger.info "Importing #{stores.length.to_s} stores"
    stores.each do |store|
      Rails.logger.info "Importing items from #{store.url}"
      store.import
      Rails.logger.info "Done"
    end
  end
end
