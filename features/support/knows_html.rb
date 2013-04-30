# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

module KnowsHtml

  def page_should_auto_refresh
    page.should have_xpath("//meta[@http-equiv='refresh']")
  end

  def page_should_contain_an_iframe(dom_id, url)
    page.should have_xpath("//iframe[@id='#{dom_id}'][@src='#{url}']")
  end

  def page_should_have_a_link(text, url)
    page.should have_xpath("//a[@href='#{url}'][contains(.,'#{text}')]")
  end

end
World(KnowsHtml)
