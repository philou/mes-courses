# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau
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


require 'spec_helper'

describe PathBarHelper do
  include PathBarHelper

  it "should build path elements with no link" do
    expect(path_bar_element_with_no_link("Going nowhere")).to eq "Going nowhere"
  end

  it "matches elements with no link" do
    expect(path_bar_element_with_no_link?(path_bar_element_with_no_link("anything"))).to eq true
    expect(path_bar_element_with_no_link?(path_bar_element_for_current_resource("anything"))).to eq false
  end

  it "should build path elements for current resource" do
    expect(path_bar_element_for_current_resource("You are here")).to eq ["You are here"]
  end

  it "should build path elements with explicit links" do
    expect(path_bar_element("Somewhere", :controller => "dispatcher")).to eq ["Somewhere", {:controller => "dispatcher"}]
  end

end
