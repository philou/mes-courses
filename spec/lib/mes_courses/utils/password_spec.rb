# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

module MesCourses
  module Utils
    describe Password do

      it "generates password starting with a vowel" do
        Password.generate.should be_starting_with(/[aeiouy]/)
      end

      it "generates password ending with a vowel" do
        Password.generate.should =~ /[aeiouy]$/
      end

      it "generates password with the specified number of vowels" do
        size = 5
        Password.generate(size).scan(/[aeiouy]/).should have_at_least(size+1).items
      end

      it "generates password with a specified size" do
        size = 4
        password = Password.generate(size)
        password.should have_at_least(2*size + 1).characters
        password.should have_at_most(3*size +1).characters
      end

    end
  end
end
