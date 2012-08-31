# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require "mes_courses/utils/scheduled_tasks"

namespace :scheduled do

  extend MesCourses::Utils::ScheduledTasks

  scheduled_task("stores:import")

  unless Rails.env == "production"
    scheduled_task("watchdog")
  end

  scheduled_task("failing")

end

