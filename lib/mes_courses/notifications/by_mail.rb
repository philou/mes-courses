# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


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
