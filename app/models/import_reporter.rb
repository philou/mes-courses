# Copyright (C) 2011 by Philippe Bourgau

require 'action_view/helpers/number_helper'

# Object responsible for building and mailing an import report
class ImportReporter < ActionMailer::Base
  class << self
    include HerokuHelper
    include ActionView::Helpers::NumberHelper
  end

  # Updates statistics and reports by mail and log
  def self.update_stats_and_report
    body = update_stats_and_generate_content
    subject = generate_subject(body)

    deliver_import_report(subject, body.inspect)
  end

  private

  def self.generate_subject(body)
    "[#{app_name}] Import "+
      if body["Item"]["previous count"] == 0
        "OK first time +#{body["Item"]["updated count"]} items"
      else
        delta = body["Item"]["delta"]
        "#{result(delta)} #{percent_delta(delta)}"
      end
  end

  def self.result(delta)
    if (delta -1).abs < 0.05
      "OK"
    else
      "WARNING"
    end
  end

  def self.percent_delta(delta)
    result = number_to_percentage(100 * (delta - 1), :precision => 2)
    if 1 <= delta
      result = '+' + result
    end
    result
  end

  def self.update_stats_and_generate_content
    stats = {
      "Root item category" => { 'previous count' => 0, 'updated count' => ItemCategory.count(:conditions => "parent_id is null") },
      "Item category" => { 'previous count' => 0, 'updated count' => ItemCategory.count },
      "Item" => { 'previous count' => 0, 'updated count' => Item.count }}

    ModelStat.find(:all).each do |model_stat|
      stats[model_stat.name]['previous count'] = model_stat.count
    end

    stats.each do |_name, stat|
      previous_count = stat['previous count']
      if (previous_count != 0)
        stat['delta'] = stat['updated count'].to_f / previous_count.to_f
      end
    end

    stats.each do |name, stat|
      ModelStat.create_or_update_by_name!(name, :count => stat['updated count'])
    end

    stats
  end

  # mailer template function
  def import_report(subject, content)
    @subject = subject
    @body["content"] = content
    @recipients = EmailConstants.recipients
    @from = EmailConstants.sender
    @sent_on = Time.now
    @headers = {}
  end

end
