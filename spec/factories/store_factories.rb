# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

FactoryGirl.define do

  sequence :url do |n|
    "#{MesCourses::Stores::DummyConstants::STORE_URL}/#{n}"
  end

  factory :store do
    url
    sponsored_url MesCourses::Stores::DummyConstants::SPONSORED_URL
  end

end
