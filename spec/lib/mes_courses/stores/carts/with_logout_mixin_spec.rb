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
  module Stores
    module Carts

      class WithLogout
        include WithLogoutMixin

        def logout
        end
      end

      describe WithLogoutMixin do

        before :each do
          @thing = WithLogout.new
        end

        it "should execute the given block" do
          block = nil
          @thing.with_logout do |t|
            block = :executed
          end
          expect(block).to be :executed
        end

        it "should call logout when everything went well" do
          expect(@thing).to receive(:logout).once

          @thing.with_logout {|t|}
        end

        it "should call logout even if an exception was raised" do
          expect(@thing).to receive(:logout).once
          begin
            @thing.with_logout { |t| raise RuntimeError.new }
          rescue
          end
        end

        it "should call propagate exceptions" do
          expect(lambda {
                   @thing.with_logout { |t| raise RuntimeError.new }
                 }).to raise_error(RuntimeError)
        end
      end
    end
  end
end
