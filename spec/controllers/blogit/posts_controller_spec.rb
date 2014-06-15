# Copyright (C) 2012 by Philippe Bourgau
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

module Blogit
  describe PostsController do

    ignore_user_authentication

    before :each do
      # to avoid : ActionController::RoutingError: No route matches {:controller=>"blogit/posts"}
      @routes = Blogit::Engine.routes
    end

    it "should assign a body id" do
      get :index

      expect(assigns[:body_id]).to eq ApplicationController::BLOG_BODY_ID
    end

    it "should assign a app part" do
      get :index

      expect(assigns[:app_part]).to eq ApplicationController::BLOG_APP_PART
    end

    it "should use a custom blog layout" do
      get :index

      expect(response).to render_template("layouts/blog")
    end

    it "computes tag frequencies" do
      Post.stub(:tag_counts).and_return(tags = double("Tags"))

      get :index

      expect(assigns[:tags]).to eq tags
    end

  end
end
