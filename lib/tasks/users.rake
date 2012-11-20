# Copyright (C) 2011, 2012 by Philippe Bourgau

namespace :mes_courses do

  desc "Creates a new user in the database with a generated password (pass in email=XXX and name=YYY)"
  task :create_user => :environment do

    name = ENV["name"]
    raise ArgumentError.new("A name must be specified") unless !name.nil?

    email = ENV["email"]
    raise ArgumentError.new("An email must be specified") unless !email.nil?

    password = MesCourses::Utils::Password.generate
    user = User.new(name: name, email: email)
    user.password = password
    user.save

    puts "Created user with"
    puts " name : #{name}"
    puts " email : #{email}"
    puts " password : #{password}"
  end

end
