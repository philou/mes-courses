# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "Jim#{n}" }
    sequence(:email) {|n| "jim#{n}@mail.com" }
    password "secret"
  end
end
