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


# Matcher to verify that many elements are present in a collection
RSpec::Matchers.define :include_all do |required_items|
  match do |actual|
    include_all?(actual,required_items)
  end
  failure_message_for_should do |actual|
    "#{missing_items(actual,required_items).inspect} are missing"
  end
  failure_message_for_should_not do |actual|
    "at least one element of #{required_items} should be absent"
  end
  description do
    "expected a collection containing all elements from #{required_items}"
  end

  #private

  def include_all?(collection,required_items)
    missing_items(collection, required_items).empty?
  end

  def missing_items(collection, required_items)
    result = []
    required_items.each do |item|
      if !collection.include?(item)
        result.push(item)
      end
    end
    result
  end

end

