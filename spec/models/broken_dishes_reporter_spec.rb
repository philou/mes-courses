# -*- encoding: utf-8 -*-
# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'
require 'models/monitoring_mailer_shared_examples'

describe BrokenDishesReporter do
  it_should_behave_like "Any MonitoringMailer"

  before(:each) do
    @mailer_class = BrokenDishesReporter
    @mailer_template = :email
    @mailer_default_parameters = [[]]
  end

  it "should have a subject about broken dishes" do
    send_monitoring_email

    @subject.should include("broken dishes")
  end

  it "should contain the yaml of all removed items" do
    removed_items = [Factory.create(:item), Factory.create(:item)]

    send_monitoring_email removed_items

    removed_items.each do |item|
      @body.should include(item.attributes.to_yaml)
    end
  end

  it "should contain the id and name of all broken dishes" do
    removed_item = Factory.create(:item)
    removed_item.dishes = [Factory.create(:dish), Factory.create(:dish)]

    send_monitoring_email [removed_item]

    removed_item.dishes.each do |dish|
      @body.should include("##{dish.id}# #{dish.name}")
    end
  end

end
