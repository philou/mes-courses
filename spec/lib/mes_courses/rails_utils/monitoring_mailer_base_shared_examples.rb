# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

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

            expect(@emails).to have(1).entry
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

        @emails = ActionMailer::Base.deliveries
        @emails.clear()

        @mailer_class.send(@mailer_template, *parameters).deliver

        @email = @emails.last
        @subject = @email.subject
        @body = @email.body
      end

    end
  end
end
