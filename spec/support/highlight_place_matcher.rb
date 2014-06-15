# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau
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


class HighlightPlace
  def initialize(text)
    @text = text
  end

  def matches?(body)
    @doc = Nokogiri::HTML(body)

    @body_id = @doc.xpath("//body/@id").text
    return false if @body_id.empty?

    !@doc.xpath(place_xpath + body_id_constraint + text_constraint).empty?
  end

  def failure_message_for_should
    if @doc.xpath(place_xpath + text_constraint).empty?
      return description + " but there is no such place"
    end

    highlighted_link = @doc.xpath(place_xpath + body_id_constraint)
    if !highlighted_link.empty?
      return description + " but '#{highlighted_link.text}' was highlighted"
    end

    return description + " but no place were highlighted"
  end

  def failure_message_for_should_not
    "expected the page not to highlight the place '#{@text}'"
  end

  def description
    "expected the page to highlight the place '#{@text}'"
  end

  private

  def place_xpath
    "//body//div[@id='places']/a"
  end
  def body_id_constraint
    "[@id='place-#{@body_id}']"
  end
  def text_constraint
    "[text()='#{@text}']"
  end

end

def highlight_place(text)
  HighlightPlace.new(text)
end
