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


module MesCourses
  module Utils
    class Tokenizer

      def self.run(string)
        string = string.downcase
        tokens = string.split(/[ \t\r\n,\.!\?;\(\):'\-]+/)
        tokens = tokens.reject { |word| is_linking?(word) }
        tokens = tokens.map &:singularize
        tokens = tokens.map { |word| remove_accents(word) }
        tokens = tokens.reject { |word| word.empty? }
        tokens = tokens.uniq

        tokens
      end

      private

      LINKING_WORDS = %w(au à en je tu il nous vous ils de du le la un une d j mais où donc or ni car ou et même)
      def self.is_linking?(word)
        LINKING_WORDS.include?(word)
      end

      ACCENTS = { 'à' => 'a',
        'â' => 'a',
        'é' => 'e',
        'è' => 'e',
        'ê' => 'e',
        'î' => 'i',
        'ô' => 'o',
        'ù' => 'u',
        'û' => 'u'}

      def self.remove_accents(text)
        result = text.dup
        ACCENTS.each do |accent, letter|
          result.gsub!(accent, letter)
        end
        result
      end
    end
  end
end
