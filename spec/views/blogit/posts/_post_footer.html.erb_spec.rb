# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe "blogit/posts/_post_footer" do

  it "renders the related posts section" do
    post = stub_model(Blogit::Post)

    render "blogit/posts/related", post: post
    expected = rendered

    render "blogit/posts/post_footer", post: post
    rendered.should == expected
  end

end

