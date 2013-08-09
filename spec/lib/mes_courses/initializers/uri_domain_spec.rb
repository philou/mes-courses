# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

describe "URI" do

  it "should extract the domain of a domain only url" do
    expect(URI.parse("http://mes-courses.fr").domain).to eq "mes-courses.fr"
  end
  it "should extract the domain of an url with a subdomain" do
    expect(URI.parse("http://www.yahoo.fr").domain).to eq "yahoo.fr"
  end
  it "should extract the domain of an url with a directories" do
    expect(URI.parse("http://www.amazon.com/books/science-fiction").domain).to eq "amazon.com"
  end
  it "should get localhost domain for a file uri" do
    expect(URI.parse("file:///home/user/documents/secret.txt").domain).to eq "localhost"
  end

  it "should get a nil domain for a local path" do
    expect(URI.parse("root/folder/and/file.txt").domain).to be_nil
  end
  it "should get a nil domain for a mailto uri" do
    expect(URI.parse("mailto:philou@mailinator.org").domain).to be_nil
  end
  it "should get a nil domain for an url with an ip address" do
    expect(URI.parse("http://192.168.0.101/index.html").domain).to be_nil
  end

end
