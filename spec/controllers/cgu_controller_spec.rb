# Copyright (C) 2014 by Philippe Bourgau
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

describe CguController do

  ignore_user_authentication

  describe "GET 'index'" do

    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end

    it "assigns an app_part" do
      get 'index'
      expect(assigns(:app_part)).to eq ApplicationController::BLOG_APP_PART
    end
  end
end
