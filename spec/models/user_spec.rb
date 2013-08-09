# -*- encoding: utf-8 -*-
require 'spec_helper'

describe User do
  it "should create a new instance given valid attributes" do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  it "should not be valid without a name" do
    expect(FactoryGirl.build(:user, name: nil)).not_to be_valid
    expect(FactoryGirl.build(:user, name: "")).not_to be_valid
  end

  it "should not be valid without an email" do
    expect(FactoryGirl.build(:user, email: nil)).not_to be_valid
    expect(FactoryGirl.build(:user, email: "")).not_to be_valid
    expect(FactoryGirl.build(:user, email: too_small="a@t.c")).not_to be_valid
  end

  it "should not be valid if it has a duplicated email" do
    FactoryGirl.create(:user, email: email = "toto@gogol.com")
    expect(FactoryGirl.build(:user, email: email)).not_to be_valid
  end
end
