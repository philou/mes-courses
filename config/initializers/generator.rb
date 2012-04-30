# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

Rails.application.config.generators do |g|
  g.test_framework = :rspec
  g.fixture_replacement :factory_girl
end
