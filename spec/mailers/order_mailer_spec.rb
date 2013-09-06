# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require "spec_helper"

describe OrderMailer do

  before :each do
    @user = "john@doe.net"
    @dishes = FactoryGirl.create_list(:dish_with_items, 2)
  end

  it "sends an email to the user" do
    deliver

    expect(email.to).to eq [@user]
  end

  it "uses an explicit subject" do
    deliver

    expect(email.subject).to eq OrderMailer::MEMO_SUBJECT
  end

  it "lists dishes and their items" do
    deliver

    @dishes.each do |dish|
      expect(email.body).to include summary_for(dish)
    end
  end

  it "pretty prints long names" do
    extra_long_dish_name = "Ceci est un super long nom pour un plat qui est vraiment très très difficile à faire mais qui est quand meme très bon"
    @dishes = [dish = FactoryGirl.create(:dish, name: extra_long_dish_name)]

    extra_long_item_name = "Ceci est un super long nom pour un ingrédient qui est vraiment très très bon mais aussi très très rare et très très cher"
    dish.items.push FactoryGirl.create(:item, name: extra_long_item_name)

    deliver

    expect(email.body.to_s.lines).to all_do have_at_most(79).characters
  end

  private

  def summary_for(dish)
    lines = [dish.name]
    lines += (dish.items.sort_by &:long_name).map do |item|
      "   * #{item.long_name}"
    end
    lines.join("\n")
  end

  def deliver
    OrderMailer.memo(@user, @dishes).deliver
  end

  def email
    emails.last
  end
  def emails
    ActionMailer::Base.deliveries
  end

end
