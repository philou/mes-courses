# Copyright (C) 2011 by Philippe Bourgau

require 'action_view/helpers/number_helper'

# Object responsible for mailing an import report
class ImportReporter < MonitoringMailer
  include ActionView::Helpers::NumberHelper

  # Reports delta from latest statistics by mail and log
  # def self.deliver_delta

  private

  def generate_subject(delta_stats)
    "Import "+
      if delta_stats[ModelStat::ITEM][:old_count] == 0
        "OK first time +#{delta_stats[ModelStat::ITEM][:count]} items"
      else
        delta = delta_stats[ModelStat::ITEM][:delta]
        "#{result(delta)} #{percent_delta(delta)}"
      end
  end

  def result(delta)
    if (delta -1).abs < 0.05
      "OK"
    else
      "WARNING"
    end
  end

  def percent_delta(delta)
    result = number_to_percentage(100 * (delta - 1), :precision => 2)
    if 1 <= delta
      result = '+' + result
    end
    result
  end

  # mailer template function
  def delta
    delta_stats = ModelStat.generate_delta
    subject = generate_subject(delta_stats)

    setup_mail(subject, :content => delta_stats.inspect)
  end

end
