# Copyright (C) 2011 by Philippe Bourgau

require 'action_view/helpers/number_helper'

# Object responsible for mailing an import report
class ImportReporter < MonitoringMailer
  include ActionView::Helpers::NumberHelper

  # Reports delta from latest statistics by mail and log
  # def self.deliver_delta

  private

  def generate_subject(delta_stats)
    item_stats = delta_stats[ModelStat::ITEM]
    "Import #{result(item_stats)} #{pretty_delta(item_stats)}"
  end

  def result(record_stats)
    delta = record_stats[:delta]

    if delta.nil?
      "OK first time"
    elsif (delta-1).abs < 0.05
      "OK"
    else
      "WARNING"
    end
  end

  def pretty_delta(item_stats)
    delta = item_stats[:delta]
    if delta.nil?
      "+#{item_stats[:count]} records"
    else
      result = number_to_percentage(100 * (delta - 1), :precision => 2)
      if 1 <= delta
        result = '+' + result
      end
      result
    end
  end

  # mailer template function
  def delta
    delta_stats = ModelStat.generate_delta
    subject = generate_subject(delta_stats)

    setup_mail(subject, :content => generate_body(delta_stats))
  end

  def generate_body(delta_stats)
    lines = ModelStat::ALL.map do |record_type|
      record_stats = delta_stats[record_type]
      "#{record_type}: #{record_stats[:old_count]} -> #{record_stats[:count]} #{pretty_delta(record_stats)}"
    end

    lines.join("\n")
  end

end
