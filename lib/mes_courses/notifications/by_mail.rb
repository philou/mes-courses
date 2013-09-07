# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

module MesCourses
  module Notifications
    module ByMail

      def notify_order_passed(cart, email)
        OrderMailer.memo(email, cart.dishes).deliver
      end

    end
  end
end
