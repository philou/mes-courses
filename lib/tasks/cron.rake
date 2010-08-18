task :cron => :environment do

  items_count = Item.count_by_sql("select count(*) from items")
  if (items_count == 0)
    puts "Starting dummy task"
    #Rake::Task["stores:import"].clear
    puts "Done"
  end

end
