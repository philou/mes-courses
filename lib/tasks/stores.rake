#load all stores, import all stores
namespace :stores do
  task :import => :environment do
    stores = Store.find(:all)
    puts "Importing #{stores.length.to_s} stores"
    stores.each do |store|
      puts "Importing items from #{store.url}"
      store.import
    end
  end
end
