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

describe WelcomeController do

  ignore_user_authentication

  before :each do
    get :index
  end

  it "should assign a body id" do
    expect(assigns[:body_id]).to eq ApplicationController::PRESENTATION_BODY_ID
  end

  it "should assign a app part" do
    expect(assigns[:app_part]).to eq ApplicationController::BLOG_APP_PART
  end

end
