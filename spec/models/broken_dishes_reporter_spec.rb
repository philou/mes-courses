# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'

describe BrokenDishesReporter do

  before(:each) do
    ENV['APP_NAME'] = "mes-courses-tests"
  end

  def send_report_email(removed_items = [])
    @emails = ActionMailer::Base.deliveries
    @emails.clear()

    BrokenDishesReporter.deliver_email removed_items

    @email = @emails.last
  end

  it "should send a non empty email" do
    send_report_email

    @emails.should have(1).entry
    @email.to.should_not be_empty
  end

  it "should have a descriptive subjet" do
    send_report_email

    @email.subject.should include(ENV['APP_NAME'])
    @email.subject.should include("broken dishes")
  end

  it "should contain the yaml of all removed items" do
    removed_items = [Factory.create(:item), Factory.create(:item)]

    send_report_email removed_items

    removed_items.each do |item|
      @email.body.should include(item.attributes.to_yaml)
    end
  end

  it "should contain the id and name of all broken dishes" do
    removed_item = Factory.create(:item)
    removed_item.dishes = [Factory.create(:dish), Factory.create(:dish)]

    send_report_email [removed_item]

    removed_item.dishes.each do |dish|
      @email.body.should include("##{dish.id}# #{dish.name}")
    end
  end

end
