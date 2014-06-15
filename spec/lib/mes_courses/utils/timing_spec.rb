# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau
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

    describe Timing do

      before :each do
        Timing.stub(:now).and_return(Time.local(2011, 11, 15, 20, 0, 0, 0))
      end

      it "should invoke the given block" do
        should_receive(:processing)

        Timing.duration_of do
          processing
        end
      end

      it "should provide the total duration to the given block" do
        Timing.duration_of do |timer|
          wait(10)
          expect(timer.seconds).to eq 10

          wait(5)
          expect(timer.seconds).to eq 15
        end
      end

      private

      def wait(seconds)
        now = Timing.now
        Timing.stub(:now).and_return(now + seconds)
      end
    end
  end
end
