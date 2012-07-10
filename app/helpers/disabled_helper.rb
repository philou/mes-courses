# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

module DisabledHelper

  def disabled_html_option_for(something)
    if something.disabled?
      {disabled: 'disabled'}
    else
      {}
    end
  end
end
