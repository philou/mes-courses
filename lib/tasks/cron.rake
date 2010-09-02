# Copyright (C) 2010 by Philippe Bourgau

desc "Performs nightly tasks, at the moment, importing items from stores"
task :cron => :environment do

  items_count = Item.count_by_sql("select count(*) from items")
  # Until the import is incremental, we don't want to launch it with existing items
  if (items_count == 0)
    Rake::Task["stores:import"].execute
  end

end
