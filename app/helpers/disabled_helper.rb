# -*- encoding: utf-8 -*-
# Copyright (C) 2012, 2013 by Philippe Bourgau

module DisabledHelper

  def disabled_html_option_for(something)
    if something.disabled?
      {disabled: 'disabled', class: 'disabled'}
    else
      {}
    end
  end
end
