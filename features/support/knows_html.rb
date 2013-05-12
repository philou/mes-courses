# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

module KnowsHtml

  def refresh_page
    visit refresh_url
  end

  def page_should_auto_refresh
    page.should have_xpath("//meta[@http-equiv='refresh']")
  end

  def page_should_contain_an_iframe(dom_id, url)
    page.should have_xpath("//iframe[@id='#{dom_id}'][@src='#{url}']")
  end

  def page_should_have_a_link(text, url)
    page.should have_xpath("//a[@href='#{url}'][contains(.,'#{text}')]")
  end

  private

  def refresh_url
    refresh_tag = page.all(:xpath, "//meta[@http-equiv='refresh']").first
    return current_path if refresh_tag.nil?

    match = /url=([^;]*)/.match(refresh_tag['content'])
    return current_path if match.nil?

    match.captures[0].tap {|o| puts "#{o} (TODO remove this print)" }
  end

end
World(KnowsHtml)
