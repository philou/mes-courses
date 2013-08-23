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


#
# GivenEither, WhenEither and ThenEither defines 2 steps in 1 call.
#   * &bloc : is the implementation of the step, taking a table as argument
#   * table_regex : is the regex with no arguments, matching the table
#   * inline_regex : is a regex matching a single textual argument, that
#     will be embedded in a one cell table before calling the block
#
# example:
#
#   GivenEither(/^I have an? ("[^"]*")$/,
#               /^I have the following animals$/) do |table|
#     create_animals(table)
#   end
#
def register_either_step_definitions(adverb, inline_regex, table_regex, &block)
  send(adverb,inline_regex) do |arg|
    self.instance_exec(cucumber_table(arg), &block)
  end
  send(adverb,table_regex, &block)
end
def GivenEither(inline_regex, table_regex, &block)
  register_either_step_definitions('Given', inline_regex, table_regex, &block)
end
def WhenEither(inline_regex, table_regex, &block)
  register_either_step_definitions('When', inline_regex, table_regex, &block)
end
def ThenEither(inline_regex, table_regex, &block)
  register_either_step_definitions('Then', inline_regex, table_regex, &block)
end
