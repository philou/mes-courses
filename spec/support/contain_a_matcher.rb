# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

class ContainA
  def initialize(page_part)
    @page_part = page_part
  end

  def matches?(page)
    @doc = Nokogiri::HTML(page.body)
    doc_contains(@page_part)
  end

  def failure_message_for_should
    failure_message_for_should_ex(@page_part)
  end

  def failure_message_for_should_not
    "expected the page not to contain #{@page_part.long_description})"
  end

  def description
    "expected the page to contain #{@page_part.long_description}"
  end

  private

  def doc_contains(page_part)
    !@doc.xpath(page_part.xpath).empty?
  end

  def failure_message_for_should_ex(page_part)
    if page_part.has_parent and !doc_contains(page_part.parent)
      failure_message_for_should_ex(page_part.parent)
    else
      description + "\nbut could not find #{page_part.long_description}"
    end
  end
end

def contain_a(page_part)
  ContainA.new(page_part)
end