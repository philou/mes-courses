# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau
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

module MesCourses
  module Utils
    describe Credentials do

      before :each do
        @email,@password = "login@me.net", "my secret password"
        @credentials = Credentials.new(@email,@password)
      end

      it "should have the provided email and password" do
        expect(@credentials.email).to eq(@email)
        expect(@credentials.password).to eq(@password)
      end

      it "implements equality" do
        expect(@credentials).to eq(Credentials.new(@email,@password))
      end

      it "should not store the password in clear when serialized" do
        @credentials.instance_variables.each do |name|
          expect(@credentials.instance_variable_get(name)).not_to include(@password)
        end
      end

      it "can be blank" do
        expect(Credentials.blank).to eq(Credentials.new('',''))
      end

    end
  end
end
