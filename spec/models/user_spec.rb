# -*- encoding: utf-8 -*-
require 'spec_helper'

describe User do
  it "should create a new instance given valid attributes" do
    FactoryGirl.build(:user).should be_valid
  end

  it "should not be valid without a name" do
    FactoryGirl.build(:user, name: nil).should_not be_valid
    FactoryGirl.build(:user, name: "").should_not be_valid
  end

  it "should not be valid without an email" do
    FactoryGirl.build(:user, email: nil).should_not be_valid
    FactoryGirl.build(:user, email: "").should_not be_valid
    FactoryGirl.build(:user, email: too_small="a@t.c").should_not be_valid
  end

  it "should not be valid if it has a duplicated email" do
    FactoryGirl.create(:user, email: email = "toto@gogol.com")
    FactoryGirl.build(:user, email: email).should_not be_valid
  end
end
