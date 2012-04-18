# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'

RSpec::Matchers.define :have_button_to do |label, href, method|
  match do |response|
    extend Webrat::Matchers

    method = method.to_s.downcase
    form_method = case method
                  when 'get'
                    'get'
                  else
                    'post'
                  end


    response.should have_selector("form", :action => href, :method => form_method) do |form|
      if ['put', 'delete'].include?(method)
        form.should have_selector("input", :type => "hidden", :name => "_method", :value => method)
      else
        form.should_not have_selector("input", :type => "hidden", :name => "_method")
      end

      form.should have_selector("input", :type => 'submit', :value => label)
    end
  end

  description do |response|
    "expected a response containing a button \"#{label}\" to \"#{href}\" using \"#{method}\" method"
  end

  failure_message_for_should do |response|
    "expected the following text to contain a button \"#{label}\" to \"#{href}\" using \"#{method}\" method\n#{Webrat::XML.document(response)}"
  end

  failure_message_for_should_not do |response|
    "expected the following text not to contain a button \"#{label}\" to \"#{href}\" using \"#{method}\" method\n#{Webrat::XML.document(response)}"
  end

end
