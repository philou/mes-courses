# -*- encoding: utf-8 -*-
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

describe SessionsController do
  include PathBarHelper
  include Devise::TestHelpers

  context "when get 'new'" do

    before :each do
      # NB see http://stackoverflow.com/questions/4291755/rspec-test-of-custom-devise-session-controller-fails-with-abstractcontrollerac for the following line :
      request.env['devise.mapping'] = Devise.mappings[:user]

      get 'new'
    end

    it "renders 'new' template" do
      expect(response).to be_success
      expect(response).to render_template('new')
    end

    it "assigns a 'Connection' path bar" do
      expect(assigns(:path_bar)).to eq [path_bar_session_root]
    end

  end

end
