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
  module Initializers
    describe "Numeric extras" do

      it "should print the number of seconds" do
        expect(15.to_pretty_duration).to eq "0h 0m 15s"
      end

      it "should ignore milliseconds" do
        expect((1.123).to_pretty_duration).to eq "0h 0m 1s"
      end

      it "should print hours and minutes" do
        expect(total_seconds(8,23,17).to_pretty_duration).to eq "8h 23m 17s"
      end

      it "should convert days to hours" do
        expect(total_seconds(48,0, 0).to_pretty_duration).to eq "48h 0m 0s"
      end

      private

      def total_seconds(hours, minutes, seconds)
        (hours*60 + minutes)*60 + seconds
      end
    end
  end
end
