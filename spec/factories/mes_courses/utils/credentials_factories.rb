# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau
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
