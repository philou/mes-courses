# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'uri_domain'

describe "URI" do

  it "should extract the domain of a domain only url" do
    URI.parse("http://mes-courses.fr").domain.should == "mes-courses.fr"
  end
  it "should extract the domain of an url with a subdomain" do
    URI.parse("http://www.yahoo.fr").domain.should == "yahoo.fr"
  end
  it "should extract the domain of an url with a directories" do
    URI.parse("http://www.amazon.com/books/science-fiction").domain.should == "amazon.com"
  end
  it "should get localhost domain for a file uri" do
    URI.parse("file:///home/user/documents/secret.txt").domain.should == "localhost"
  end

  it "should get a nil domain for a local path" do
    URI.parse("root/folder/and/file.txt").domain.should be_nil
  end
  it "should get a nil domain for a mailto uri" do
    URI.parse("mailto:philou@mailinator.org").domain.should be_nil
  end
  it "should get a nil domain for an url with an ip address" do
    URI.parse("http://192.168.0.101/index.html").domain.should be_nil
  end

end
