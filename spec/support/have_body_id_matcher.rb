# -*- encoding: utf-8 -*-
# Copyright (C) 2011 by Philippe Bourgau

class HaveBodyId
  def initialize(expected_body_id)
    @expected_body_id = expected_body_id
  end

  def matches? (response)
    @doc = Nokogiri::HTML(response.body)
    !@doc.xpath("/html/body[@id='#{@expected_body_id}']").empty?
  end

  def failure_message_for_should
    body = @doc.xpath("/html/body")
    description + " but was '#{body[:id]}'"
  end

  def failure_message_for_should_not
    "expected the body of the html page not to have id '#{@expected_body_id}'"
  end

  def description
    "expected the body of the html page to have id '#{@expected_body_id}'"
  end
end

def have_body_id(expected_body_id)
  HaveBodyId.new(expected_body_id)
end
