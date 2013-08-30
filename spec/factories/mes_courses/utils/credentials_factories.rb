# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

FactoryGirl.define do
  sequence(:login) {|n| "toto#{n}@gyzmo.com" }
  sequence(:password) {|n| "secret number #{n}"}

  factory :credentials, class: MesCourses::Utils::Credentials do
    ignore do
      login
      password
    end
    initialize_with {new( login,password) }
  end

  factory :valid_credentials, class: MesCourses::Utils::Credentials do
    initialize_with {new(MesCourses::Stores::Carts::Api.valid_email,MesCourses::Stores::Carts::Api.valid_password) }
  end
end
