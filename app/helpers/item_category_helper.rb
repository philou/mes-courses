# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

module ItemCategoryHelper
  include DisabledHelper

  def button_to_add_item(item, label, url_options, html_options)
    button_to h(label), url_options.merge(:id => item.id), html_options.merge(disabled_html_option_for(item))
  end

end
