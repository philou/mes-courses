# -*- encoding: utf-8 -*-
# Copyright (C) 2011 by Philippe Bourgau
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


class HaveBodyId
  def initialize(expected_body_id)
    @expected_body_id = expected_body_id
  end

  def matches? (response)
    @doc = Nokogiri::HTML(response.body)
    !@doc.xpath("/html/body[@id='#{@expected_body_id}']").empty?
  end

  def failure_message_for_should
    body = @doc.xpath("/html/body")
    description + " but was '#{body[:id]}'"
  end

  def failure_message_for_should_not
    "expected the body of the html page not to have id '#{@expected_body_id}'"
  end

  def description
    "expected the body of the html page to have id '#{@expected_body_id}'"
  end
end

def have_body_id(expected_body_id)
  HaveBodyId.new(expected_body_id)
end
