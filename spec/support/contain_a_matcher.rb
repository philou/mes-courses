# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

class ContainA
  def initialize(page_part)
    @page_part = page_part
  end

  def matches?(page)
    @doc = Nokogiri::HTML(body_of(page))
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

  def body_of(page)
    if page.respond_to?(:body)
      page.body
    else
      page
    end
  end

  def doc_contains(page_part)
    !@doc.xpath(page_part.xpath).empty?
  end

  def failure_message_for_should_ex(page_part)
    if parent_cannot_be_found(page_part)
      failure_message_for_should_ex(page_part.parent)
    elsif !page_part.has_parent
      [description,
       "but could not find #{page_part.long_description}"].join("\n")
    else
      [description,
       "it found #{page_part.parent.long_description}",
       "but not #{page_part.long_description}"].join("\n")
    end
  end

  def parent_cannot_be_found(page_part)
    page_part.has_parent and !doc_contains(page_part.parent)
  end
end

def contain_a(page_part)
  ContainA.new(page_part)
end
