# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module Utils
    describe UrlHelper do
      include UrlHelper

      it "should convert http urls to https" do
        expect(https_url("http://toto.com")).to eq "https://toto.com"
      end

      it "should not change https urls" do
        expect(https_url("https://toto.com")).to eq "https://toto.com"
      end

      it "should not change file uris" do
        expect(https_url("file:///tmp/toto.com")).to eq "file:///tmp/toto.com"
      end

    end
  end
end
