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
  module RailsUtils

    # base mailer class for online maintainer monitoring
    class MonitoringMailerBase < ActionMailer::Base
      include MesCourses::Utils::HerokuHelper
      extend MesCourses::Utils::EmailConstants

      default :from => watchdog_email, :to => maintainers_emails

      def setup_mail(subject)
        mail :subject => "[#{app_name}] " + subject, :date => Time.now
      end
    end
  end
end
