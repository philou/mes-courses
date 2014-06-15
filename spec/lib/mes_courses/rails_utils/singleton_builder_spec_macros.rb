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

module MesCourses
  module RailsUtils
    module SingletonBuilderSpecMacros

      def has_singleton(symbol, value)

        singleton = described_class.send(symbol)
        factory_name = described_class.to_s.underscore.intern

        it "has a #{symbol} that is marked so" do
          expect(singleton).to self.send("be_#{symbol}")
        end

        it "has other categories that are not #{symbol}" do
          expect(FactoryGirl.build(factory_name)).not_to self.send("be_#{symbol}")
        end

        it "publishes the name of #{symbol} directly" do
          expect(described_class.send("#{symbol}_name")).to eq value
        end

        it "has a #{symbol} with a special name" do
          expect(singleton.name).to eq value
        end
      end
    end
  end
end
