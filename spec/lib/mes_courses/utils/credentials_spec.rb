# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module Utils
    describe Credentials do

      before :each do
        @login,@password = "my login", "my secret password"
      end

      it "should have the provided login and password" do
        credentials = Credentials.new(@login,@password)

        credentials.login.should == @login
        credentials.password.should == @password
      end

      it "implements equality" do
        Credentials.new(@login,@password).should == Credentials.new(@login,@password)
      end

    end
  end
end
