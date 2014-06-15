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
    describe Tokenizer do

      it "should return an array with the given words" do
        tokens = Tokenizer.run("petit poi (extra fin)\r\n\t--- produit france, provence. poid net : 14g; trace xxx ? !")
        expect(tokens).to eq %w(petit poi extra fin produit france provence poid net 14g trace xxx)
      end

      it "should remove irrelevant linking words" do
        tokens = Tokenizer.run("riz au saumon, produit en france, plat à cuire")
        expect(tokens).to eq %w(riz saumon produit france plat cuire)
      end

      it "should singularize words" do
        expect(Tokenizer.run("tomates")).to eq ['tomate']
      end

      it "should downcase words" do
        expect(Tokenizer.run("Confiture")).to eq ["confiture"]
      end

      it "should remove accents" do
        expect(Tokenizer.run("pâte")).to eq ["pate"]
      end

      it "should remove duplicates" do
        expect(Tokenizer.run("creme creme")).to eq ["creme"]
      end

      it "removes empty or trimed words" do
        expect(Tokenizer.run("s")).to eq []
      end
    end
  end
end
