# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

module KnowsHtml

  def refresh_page
    visit refresh_url
  end

  def page_should_auto_refresh
    expect(meta_refresh_tags).not_to(be_empty, "could not find a meta refresh tag")
  end

  def current_route_should_be(named_route, *regexps)
    params = regexps.each_with_index.map {|r, i| ":id#{i}" }
    path = self.send(named_route, *params)
    params.zip(regexps).map do |param, regex|
      path = path.gsub(param, regex.to_s)
    end
    path_regex = Regexp.new(path)

    expect(current_path).to match(path_regex)
  end

  def page_should_contain_an_iframe(dom_class, url = nil)
    xpath = "//iframe[@class='#{dom_class}']"
    xpath = xpath + "[@src='#{url}']" unless url.nil?

    expect(page).to have_xpath(xpath)
  end

  def page_should_have_a_link(text, url)
    expect(page).to have_xpath("//a[@href='#{url}'][contains(.,'#{text}')]")
  end

  private

  def refresh_url
    refresh_tag = meta_refresh_tags.first
    return current_path if refresh_tag.nil?

    match = /url=([^;]*)/.match(refresh_tag['content'])
    return current_path if match.nil?

    match.captures[0]
  end

  def meta_refresh_tags
    Nokogiri::HTML(page.source).xpath("//meta[@http-equiv='refresh']")
  end

end
World(KnowsHtml)
