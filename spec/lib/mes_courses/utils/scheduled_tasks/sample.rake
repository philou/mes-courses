# Copyright (C) 2011, 2012 by Philippe Bourgau

require "mes_courses/utils/scheduled_tasks"



namespace :scheduled do
  extend MesCourses::Utils::ScheduledTasks

  scheduled_task("sample")
end
