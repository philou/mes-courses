# Copyright (C) 2010 by Philippe Bourgau

desc "Performs nightly tasks, at the moment, importing items from stores"
task :cron => :environment do

  at_exit do
    Rails.logger.info "Exited, last exception was #{$!.inspect}"
  end

  Rake::Task["stores:import"].execute

end
