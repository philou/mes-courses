# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'
require 'lib/mes_courses/rails_utils/monitoring_mailer_base_shared_examples'

module ImportReporterSpecMacros

  def self.included(base)
    base.send :include, MesCourses::RailsUtils::MonitoringMailerBaseSpecMacros
    base.send :extend, ClassMethods
  end

  module ClassMethods

    def it_should_behave_like_any_import_reporter

      before :each do
        @mailer_class = ImportReporter
        @mailer_template = :delta
        @total_duration = 7341
        @mailer_default_parameters = [@total_duration, 0]
        ModelStat.stub(:generate_delta).and_return(@stats)
      end

      it_should_behave_like_any_monitoring_mailer

      it "should have a subject with item count delta" do
        send_monitoring_email

        expect(@subject).to include(@stats["Item"]['% delta'])
      end

      it "should have a subject containing \"OK\" for deltas smaller than 5%" do
        send_monitoring_email

        expect(@subject).to include("OK")
        expect(@subject).not_to include("WARNING")
      end

      it "should have a subjet containing \"WARNING\" when there are less items than expected" do
        send_monitoring_email(@total_duration, @stats[ModelStat::ITEM][:count] + 1)

        expect(@subject).to include("WARNING")
        expect(@subject).not_to include("OK")
      end

      it "should have a subjet containing \"OK\" when there are no stores to import" do
        send_monitoring_email(@total_duration, nil)

        expect(@subject).to include("OK")
        expect(@subject).not_to include("WARNING")
      end

      it "should contain a line describing the delta of each record type" do
        send_monitoring_email

        ModelStat::ALL.each do |record_type|
          record_stats = @stats[record_type]
          expect(@body).to include("#{record_type}: #{record_stats[:old_count]} -> #{record_stats[:count]} #{record_stats['% delta']}")
        end
      end

      it "should contain a line with the total import duration" do
        send_monitoring_email

        expect(@body).to include("Import took : #{@total_duration.to_pretty_duration}")
      end

      should_contain_the_logs

    end
  end

end

describe ImportReporter do
  include ImportReporterSpecMacros

  context "during an incremental import" do

    before :each do
      @stats = { ModelStat::ROOT_CATEGORY => {:old_count => 1, :count => 2, :delta => 2.0, '% delta' => "+100.00%"},
                 ModelStat::CATEGORY => {:old_count => 4, :count => 8, :delta => 2.0, '% delta' => "+100.00%"},
                 ModelStat::ITEM => {:old_count => 100, :count => 99, :delta => 0.99, '% delta' => "-1.00%"}}
    end

    it_should_behave_like_any_import_reporter

    it "should have a subjet containing \"WARNING\" for deltas greater than 5%" do
      @stats["Item"] = {:old_count => 20, :count => 27, :delta => 1.35, '% delta' => "+35.00%"}

      send_monitoring_email

      expect(@subject).to include("WARNING")
      expect(@subject).not_to include("OK")
    end

  end

  context "during a first import" do
    before :each do
      @stats = { ModelStat::ROOT_CATEGORY => {:old_count => 0, :count => 2, '% delta' => "+2"},
                 ModelStat::CATEGORY => {:old_count => 0, :count => 8, '% delta' => "+8"},
                 ModelStat::ITEM => {:old_count => 0, :count => 27, '% delta' => "+27"}}
    end

    it_should_behave_like_any_import_reporter
  end


end
