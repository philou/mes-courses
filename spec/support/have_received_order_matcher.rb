# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2013 by Philippe Bourgau

RSpec::Matchers.define :have_received_order do |cart, credentials|
  match do |dummy_api|
    not dummy_api.nil? and
    dummy_api.login == credentials.email and
    dummy_api.password == credentials.password and
    cart.lines.all? do |cart_line|
      cart.content.include?(cart_line.item.remote_id)
    end
  end

  failure_message_for_should do |dummy_api|
    "expected #{dummy_api.inspect} to have received order #{cart.inspect} from #{credentials}"
  end
end
