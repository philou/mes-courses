# Copyright (C) 2011 by Philippe Bourgau

class AddTokensToItem < ActiveRecord::Migration

  # Copied from tokenizer.rb and item.rb at the date of the migration
  class Tokenizer

    def self.run(string)
      string = string.downcase
      tokens = string.split(/[ \t\r\n,\.!\?;\(\):'\-]+/)
      tokens = tokens.reject { |word| is_linking?(word) }
      tokens = tokens.map &:singularize
      tokens = tokens.map { |word| remove_accents(word) }
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
  class Item < ActiveRecord::Base
    def index
      self.tokens = Tokenizer.run("#{name} #{summary}").join(" ")
    end
  end
  # end copy

  def self.up
    add_column :items, :tokens, :string

    Item.find(:all).each do |item|
      item.index
      item.save!
    end

    change_column :items, :tokens, :string, :null => false
  end

  def self.down
    remove_column :items, :tokens
  end
end
