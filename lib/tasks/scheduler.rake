# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require "mes_courses/utils/scheduled_tasks"

namespace :scheduled do

  extend MesCourses::Utils::ScheduledTasks

  scheduled_task("stores:import")

  scheduled_task("watchdog")

  scheduled_task("failing")

end
