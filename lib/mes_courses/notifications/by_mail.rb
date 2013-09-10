# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

module MesCourses
  module Notifications
    module ByMail

      def notify_order_passed(cart, email)
        OrderMailer.memo(email, cart.dishes).deliver
      end

      def notify_stores_imported(duration)
        ImportReporter.delta(duration.seconds, Store.maximum(:expected_items)).deliver
      end

      def notify_broken_dishes(dish_breaking_items)
        BrokenDishesReporter.email(dish_breaking_items).deliver
      end

      def notify_scheduled_task_failure(task, exception)
        CronTaskFailureReporter.failure(task, exception).deliver
      end

    end
  end
end
