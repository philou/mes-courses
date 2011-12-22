# Copyright (C) 2011 by Philippe Bourgau

class HighlightPlace
  def initialize(text)
    @text = text
  end

  def matches?(response)
    @response = response
    @doc = Nokogiri::HTML(@response.body)

    @body_id = @doc.xpath("//body/@id").text
    return false if @body_id.empty?

    !@doc.xpath(place_xpath + body_id_constraint + text_constraint).empty?
  end

  def failure_message_for_should
    if @doc.xpath(place_xpath + text_constraint).empty?
      return description + " but there is no such place"
    end

    highlighted_link = @doc.xpath(place_xpath + body_id_constraint)
    if !highlighted_link.empty?
      return description + " but '#{highlighted_link.text}' was highlighted"
    end

    return description + " but no place were highlighted"
  end

  def failure_message_for_should_not
    "expected the page not to highlight the place '#{@text}'"
  end

  def description
    "expected the page to highlight the place '#{@text}'"
  end

  private

  def place_xpath
    "//body//div[@id='places']/a"
  end
  def body_id_constraint
    "[@id='place-#{@body_id}']"
  end
  def text_constraint
    "[text()='#{@text}']"
  end

end

def highlight_place(text)
  HighlightPlace.new(text)
end
