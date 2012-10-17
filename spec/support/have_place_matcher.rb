# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

class HavePlace
  def initialize(options)
    @text = options[:text]
    @url = options[:url]
  end

  def matches?(response)
    @doc = Nokogiri::HTML(response)

    !@doc.xpath(place_xpath).empty?
  end

  def failure_message_for_should
    if @doc.xpath(place_bar_xpath).empty?
      description + " but no place bar was found"

    elsif @doc.xpath(place_name_xpath).empty?
      places = @doc.xpath(places_xpath).map { |link| link.text }
      description + " but it was not found among places (#{places.join(', ')})"

    else # @doc.xpath(place_xpath).empty?
      link = @doc.xpath(place_name_xpath)
      description + " but it is linking to '#{link.attribute('href').value}'"

    end
  end

  def failure_message_for_should_not
    "expected the page not to have a place '#{@text}' linking to '#{@url}'"
  end

  def description
    "expected the page to have a place '#{@text}' linking to '#{@url}'"
  end

  private

  def place_bar_xpath
    "//div[@id='places']"
  end
  def places_xpath
    "#{place_bar_xpath}/a"
  end
  def place_name_xpath
    "#{places_xpath}[text()='#{@text}']"
  end
  def place_xpath
    "#{place_name_xpath}[@href='#{@url}']"
  end

end

def have_place(options)
  HavePlace.new(options)
end
