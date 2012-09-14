# Copyright (C) 2011, 2012 by Philippe Bourgau

require "spec_helper"
require "rake"

module MesCourses
  module Utils

    describe ScheduledTasks do

      # could be pushed to a shared_context or a macro if we wanted to test more tasks
      let(:rake)      { Rake::Application.new }
      # let(:task_name)
      # let(:task_path)
      subject         { rake[task_name] }

      def loaded_files_excluding_current_rake_file
        $".reject {|file| file == Rails.root.join("#{task_path}.rake").to_s }
      end

      before do
        Rake.application = rake
        Rake.application.rake_require(task_path, [Rails.root.to_s], loaded_files_excluding_current_rake_file)

        Rake::Task.define_task(:environment)
      end
      #end shared_context


      let(:task_name) { "scheduled:sample" }
      let(:task_path) { "spec/lib/mes_courses/utils/scheduled_tasks/sample" }
      let(:sample_task) { stub("sample_task").as_null_object }

      before do
        Rake::Task.define_task(:sample) { sample_task.invoke }
      end

      it "calls the main task by default" do
        sample_task.should_receive(:invoke)
        subject.invoke
      end

      it "calls the main task if XXX_DAY_OF_WEEK is set to today" do
        with_sample_day_of_week(Time.now) do
          sample_task.should_receive(:invoke)
          subject.invoke
        end
      end

      def with_sample_day_of_week(time)
        key = "SAMPLE_DAY_OF_WEEK"
        begin
          ENV[key] = time.getutc.wday.to_s
          yield
        ensure
          ENV.delete(key)
        end
      end

      it "does not call the main task if XXX_DAY_OF_WEEK is set to another day" do
        one_day = 24*60*60
        with_sample_day_of_week(Time.now + one_day) do
          sample_task.should_not_receive(:invoke)
          subject.invoke
        end
      end

      it "sends failure emails" do
        sample_task.stub(:invoke).and_throw(RuntimeError.new("It did a bad, bad thing !"))
        CronTaskFailureReporter.should_receive(:failure).with("sample", anything()).and_return(email = stub(CronTaskFailureReporter))
        email.should_receive(:deliver)

        subject.invoke
      end

      # it "uses utc times"
    end
  end
end
