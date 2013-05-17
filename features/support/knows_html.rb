# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

module KnowsHtml

  def refresh_page
    visit refresh_url
  end

  def page_should_auto_refresh
    page.should have_xpath("//meta[@http-equiv='refresh']")
  end

  def current_route_should_be(named_route, *regexps)
    params = regexps.each_with_index.map {|r, i| ":id#{i}" }
    path = self.send(named_route, *params)
    params.zip(regexps).map do |param, regex|
      path = path.gsub(param, regex.to_s)
    end
    path_regex = Regexp.new(path)

    current_path.should match(path_regex)
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

    match.captures[0]
  end

end
World(KnowsHtml)
