# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau
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


require 'spec_helper'

module MesCourses
  module RailsUtils

    module MonitoringMailerBaseSpecMacros

      def self.included(base)
        base.send :extend, ClassMethods
      end

      module ClassMethods

        HerokuHelper = MesCourses::Utils::HerokuHelper

        def it_should_behave_like_any_monitoring_mailer
          before(:each) do
            HerokuHelper.stub(:app_name).and_return("mes-courses-tests")
          end

          it "should send a non empty email" do
            send_monitoring_email

            expect(@email.to).not_to be_empty
          end

          it "should have a subject including the app name" do
            send_monitoring_email

            expect(@subject).to include(HerokuHelper.app_name)
          end
        end

        def should_contain_the_logs
          it "should contain the logs" do
            log_text = "all the long logs"
            HerokuHelper.stub(:safe_heroku_logs).and_return(log_text)

            send_monitoring_email

            expect(@body).to include(log_text)
          end
        end
      end

      def send_monitoring_email(*parameters)
        parameters = @mailer_default_parameters if parameters.empty?

        @email = @mailer_class.send(@mailer_template, *parameters)

        @subject = @email.subject
        @body = @email.body
      end

    end
  end
end
