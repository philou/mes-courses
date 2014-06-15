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

describe User do
  it "should create a new instance given valid attributes" do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  it "should not be valid without a name" do
    expect(FactoryGirl.build(:user, name: nil)).not_to be_valid
    expect(FactoryGirl.build(:user, name: "")).not_to be_valid
  end

  it "should not be valid without an email" do
    expect(FactoryGirl.build(:user, email: nil)).not_to be_valid
    expect(FactoryGirl.build(:user, email: "")).not_to be_valid
    expect(FactoryGirl.build(:user, email: too_small="a@t.c")).not_to be_valid
  end

  it "should not be valid if it has a duplicated email" do
    FactoryGirl.create(:user, email: email = "toto@gogol.com")
    expect(FactoryGirl.build(:user, email: email)).not_to be_valid
  end
end
