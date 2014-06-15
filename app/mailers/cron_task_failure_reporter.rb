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


# Object responsible for mailing cron task failures
class CronTaskFailureReporter < MesCourses::RailsUtils::MonitoringMailerBase
  include MesCourses::Utils::HerokuHelper

  def failure(task_name, exception)
    setup_content(exception)
    setup_mail(subject(task_name, exception))
  end

  private

  def setup_content(exception)
    @backtrace = exception.backtrace.join("\n")
    @logs = safe_heroku_logs
  end

  def subject(task_name, exception)
    "ERROR task '#{task_name}' (#{exception.class.name}) #{exception.message}"
  end
end
