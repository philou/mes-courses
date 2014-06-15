# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau
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
    describe UrlHelper do
      include UrlHelper

      it "should convert http urls to https" do
        expect(https_url("http://toto.com")).to eq "https://toto.com"
      end

      it "should not change https urls" do
        expect(https_url("https://toto.com")).to eq "https://toto.com"
      end

      it "should not change file uris" do
        expect(https_url("file:///tmp/toto.com")).to eq "file:///tmp/toto.com"
      end

    end
  end
end
