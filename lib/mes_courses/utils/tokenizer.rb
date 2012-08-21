# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

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
