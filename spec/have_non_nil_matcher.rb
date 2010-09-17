# Copyright (C) 2010 by Philippe Bourgau

# Matcher to verify that an object responds to :attribute and returns something not null
Spec::Matchers.define :have_non_nil do |attribute|
  match do |actual|
    !actual.send(attribute).nil?
  end
  failure_message_for_should do |actual|
    "#{actual}.#{attribute} is nil"
  end
  failure_message_for_should_not do |actual|
    "#{actual}.#{attribute} is not nil"
  end
  description do
    "expected an object responding something not null to #{attribute}"
  end
end
