
task :invoked => :environment do
  puts "STDOUT from invoked"
  Rails.logger.info "Info log in invoked"
  Rails.logger.fatal "Fatal log in invoked"

  throw RuntimeError.new("exception from invoked")
end

task :dependency => :environment do
  puts "STDOUT from dependency"
  Rails.logger.info "Info log in dependency"
  Rails.logger.fatal "Fatal log in dependency"

  #throw RuntimeError.new("exception from dependency")
end

task :test2 => :environment do
  Exceptional.rescue "Invoking test" do
    Rake::Task[:test].invoke
  end
end

task :test3 => :environment do
  begin
    Rake::Task[:test].invoke
  rescue Exception => e
    puts "caught exception #{e.inspect}"
  end
end

desc "Performs nightly tasks"
task :cron => [:environment, :dependency] do
  ENV['RAILS_ENV'] = RAILS_ENV = 'production'

  Exceptional.rescue "Invoking invoked" do
    Rake::Task[:invoked].invoke
  end
end
