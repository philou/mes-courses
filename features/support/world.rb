# -*- encoding: utf-8 -*-
# Copyright (C) 2012, 2013 by Philippe Bourgau

# custom matchers
require_relative '../../spec/support/mostly_matcher'
require_relative '../../spec/support/have_non_nil_matcher'
require_relative '../../spec/support/have_place_matcher'
require_relative '../../spec/support/highlight_place_matcher'
require_relative '../../spec/support/have_body_id_matcher'
require_relative '../../spec/support/contain_a_matcher'
require_relative '../../spec/support/page_part'
require_relative '../../spec/support/knows_page_parts'
require_relative '../../spec/support/rspec_proxies'
require_relative '../../lib/mes_courses/utils/url_helper'
require_relative '../../lib/mes_courses/utils/email_constants'
require 'email_spec'

World(KnowsPageParts)
World(MesCourses::Utils::UrlHelper)
World(MesCourses::Utils::EmailConstants)
World(EmailSpec::Helpers)
World(EmailSpec::Matchers)

module KnowsUsers
  def user
    @user ||= FactoryGirl.create(:user, email: "email@email.com", password: "password")
  end
end
World(KnowsUsers)
