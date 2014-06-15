# -*- encoding: utf-8 -*-
# Copyright (C) 2012, 2013, 2014 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


# custom matchers
require_relative '../../spec/support/have_non_nil_matcher'
require_relative '../../spec/support/have_place_matcher'
require_relative '../../spec/support/highlight_place_matcher'
require_relative '../../spec/support/have_body_id_matcher'
require_relative '../../spec/support/knows_page_parts'
require_relative '../../lib/mes_courses/utils/url_helper'
require_relative '../../lib/mes_courses/utils/email_constants'
require 'rspecproxies'
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
