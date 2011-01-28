# Copyright (C) 2010, 2011 by Philippe Bourgau

desc "Performs nightly tasks, at the moment, importing items from stores"
task :cron => :environment do
  Rails.logger.mongoize do
    at_exit do
      Rails.logger.info "Exited, last exception was #{$!.inspect}"
    end
    Rake::Task["stores:import"].invoke
  end
end
