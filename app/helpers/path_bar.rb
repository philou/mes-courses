# Copyright (C) 2011 by Philippe Bourgau

module PathBar

  # Path bar element with no link
  def self.element_with_no_link(text)
    text
  end

  # path bar element with a default link (current controller and action)
  # ignores eventual GET parameters
  def self.element_for_current_resource(text)
    [text]
  end

  # path bar element with a link to url_for(options)
  def self.element(text, url_for_options = {})
    [text, url_for_options]
  end

end
