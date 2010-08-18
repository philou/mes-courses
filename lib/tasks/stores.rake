namespace :stores do
  desc "Import all existing stores"
  task :import => :environment do
    stores = Store.find(:all)
    puts "Importing #{stores.length.to_s} stores"
    stores.each do |store|
      puts "Importing items from #{store.url}"
      store.import
      puts "Done"
    end
  end
end
