# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau
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

describe "sessions/new" do

  it "should display :password in french" do
    view.stub(:resource_name).and_return(:user)
    view.stub(:resource).and_return(stub_model(User))
    view.stub(:devise_mapping).and_return(double("devise mapping", :rememberable? => false, :registerable? => false, :recoverable? => false, :confirmable? => false, :lockable? => false, :omniauthable? => false))

    render

    expect(rendered).to contain("Mot de passe")
    expect(rendered).not_to contain("Password")
  end

end
