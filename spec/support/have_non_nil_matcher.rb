# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2012 by Philippe Bourgau
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


# Matcher to verify that an object responds to :attribute and returns something not null
RSpec::Matchers.define :have_non_nil do |attribute|
  match do |actual|
    !actual.send(attribute).nil?
  end
  failure_message_for_should do |actual|
    "#{actual}.#{attribute} is nil"
  end
  failure_message_for_should_not do |actual|
    "#{actual}.#{attribute} is not nil"
  end
  description do
    "expected an object responding something not null to #{attribute}"
  end
end
