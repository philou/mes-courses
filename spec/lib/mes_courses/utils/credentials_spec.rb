# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module Utils
    describe Credentials do

      before :each do
        @login,@password = "my login", "my secret password"
        @credentials = Credentials.new(@login,@password)
      end

      it "should have the provided login and password" do
        expect(@credentials.login).to eq(@login)
        expect(@credentials.password).to eq(@password)
      end

      it "implements equality" do
        expect(@credentials).to eq(Credentials.new(@login,@password))
      end

      it "should not store the password in clear when serialized" do
        @credentials.instance_variables.each do |name|
          expect(@credentials.instance_variable_get(name)).not_to include(@password)
        end
      end

    end
  end
end
