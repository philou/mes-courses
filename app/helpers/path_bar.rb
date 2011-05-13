# Copyright (C) 2011 by Philippe Bourgau

module PathBar

  def self.element_with_no_link(text)
    text
  end

  def self.element_for_current_resource(text)
    [text]
  end

  def self.element(text, options = {})
    [text, options]
  end

end
