# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

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
    assign(:tags, [stub("tagging", name: "cuisine", count: 3)])
    render
    rendered.should contain_a(link_to_posts_with_tag("cuisine").within_a(blog_sidebar_section("tags")))
  end

  it "renders a post archive" do
    view.should_receive(:blog_posts_archive_tag)
    render
    rendered.should contain_a(blog_sidebar_section("archive"))
  end
end

