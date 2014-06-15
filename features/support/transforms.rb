# -*- encoding: utf-8 -*-
# Copyright (C) 2013, 2014 by Philippe Bourgau
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


require 'cucumber_tricks'

CAPTURE_PERCENTAGE = Transform(/^\d+%$/) do |digits|
  digits.to_f
end

CAPTURE_STORE_NAME = NameOrPronounTransform('store', 'www.dummy-store.com')
CAPTURE_DISH_NAME = NameOrPronounTransform('dish', 'Pizza pommes de terre')
CAPTURE_ITEM_NAME = NameOrPronounTransform('item', 'Patates')
CAPTURE_EMAIL = NameOrPronounTransform('email', 'joe@mail.com')

CAPTURE_AMOUNT = Transform(/^(\d+(\.\d+)?)€$/) do |whole, _fraction|
  whole.to_f
end
