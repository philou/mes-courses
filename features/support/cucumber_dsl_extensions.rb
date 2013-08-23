# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

#
# Special capture form able to match short pronoun forms.
# NameOrPronounTransform('tool', 'hammer') would use the regex
#
#   /^(a|an|the|this) tool( "([^"]*)")?$/
#
# Allowing to match things like
#
#  * the tool "saw"
#  * a tool
#  * this tool
#
# The first time this capture is matched in a scenario, the given value
# is stored for any subsequent capture where no value is specified.
#
# If ever the first capture does not provide an explicit value, then
# the given default value is used (aka 'hammer' in the previous example)
#
def NameOrPronounTransform(kind, default_value)

  knows_this_kind_of_things = Module.new do
    self.send(:define_method, "main_#{kind}_name") do
      @main_value ||= default_value
    end
    self.send(:define_method, "register_#{kind}_name") do |value|
      @main_value ||= value
    end
  end

  World(knows_this_kind_of_things)

  Transform(/^(a|an|the|this) #{kind}( "([^"]*)")?$/) do |_prefix, _quoted_thing_name, thing_name|
    if thing_name.nil?
      self.send("main_#{kind}_name")
    else
      self.send("register_#{kind}_name",thing_name)
      thing_name
    end
  end
end
