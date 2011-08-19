# Copyright (C) 2011 by Philippe Bourgau

Then /^the body id should be "([^"]*)""?$/ do |body_id|
  response.should have_xpath("/html/body[@id='#{body_id}']")
end

