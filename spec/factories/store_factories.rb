# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

FactoryGirl.define do

  factory :store do
    url MesCourses::Stores::DummyConstants::STORE_URL
    sponsored_url MesCourses::Stores::DummyConstants::SPONSORED_URL
  end

end
