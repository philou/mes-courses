# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'lib/password'

namespace :mes_courses do

  desc "Creates a new user in the database with a generated password (with email=toto@mail.com)"
  task :create_user => :environment do

    email = ENV["email"]
    raise ArgumentError.new("An email must be specified") unless !email.nil?

    password = Password.generate
    User.create(:email => email, :password => password)

    puts "Created user with"
    puts " email : #{email}"
    puts " password : #{password}"
  end

end
