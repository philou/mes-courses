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


require 'spec_helper'
require_relative "shared_examples_for_any_layout"

describe "layouts/blog" do
  include KnowsPageParts

  before :each do
    assign :tags, []
    assign :body_id, ApplicationController::BLOG_BODY_ID
    assign :path_bar, []
    assign :session_place_text, "Connection"
    assign :session_place_url, "/sessions"
    assign :app_part, "whatever"

    view.stub(:blog_posts_archive_tag)
  end

  it_behaves_like "any layout"

  it "renders a tag cloud" do
    assign(:tags, [double("tagging", name: "cuisine", count: 3)])
    render
    expect(rendered).to contain_a(link_to_posts_with_tag("cuisine").within_a(blog_sidebar_section("tags")))
  end

  it "renders a post archive" do
    expect(view).to receive(:blog_posts_archive_tag)
    render
    expect(rendered).to contain_a(blog_sidebar_section("archive"))
  end
end

