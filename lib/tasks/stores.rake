namespace :stores do
  desc "Import all existing stores"
  task :import => :environment do
    stores = Store.find(:all)
    puts "Importing #{stores.length.to_s} stores"
    stores.each do |store|
      puts "[#{Time.now}]Importing items from #{store.url}"
      store.import
      puts "[#{Time.now}]Done"
    end
  end
end
