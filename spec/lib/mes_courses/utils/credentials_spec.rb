# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module Utils
    describe Credentials do

      before :each do
        @email,@password = "login@me.net", "my secret password"
        @credentials = Credentials.new(@email,@password)
      end

      it "should have the provided email and password" do
        expect(@credentials.email).to eq(@email)
        expect(@credentials.password).to eq(@password)
      end

      it "implements equality" do
        expect(@credentials).to eq(Credentials.new(@email,@password))
      end

      it "should not store the password in clear when serialized" do
        @credentials.instance_variables.each do |name|
          expect(@credentials.instance_variable_get(name)).not_to include(@password)
        end
      end

    end
  end
end
