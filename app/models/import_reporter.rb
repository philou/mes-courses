# Copyright (C) 2011 by Philippe Bourgau

# Object responsible for building and mailing an import report
class ImportReporter < ActionMailer::Base

  # Updates statistics and reports by mail and log
  def self.update_stats_and_report
    body = ""
    subject = subject do
      body = update_stats_and_generate_content
    end

    Rails.logger.info subject+"\n"+body

    deliver_import_report(subject, body)
  end

  private

  def self.subject
    previous_date = ModelStat.maximum(:updated_at)
    yield
    update_date = ModelStat.maximum(:updated_at)
    "Import report for app '#{app_name}' between #{previous_date} and #{update_date}"
  end
  def self.app_name
    ENV['APP_NAME'] || 'unknown'
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
      stat['delta'] = stat['updated count'].to_f / stat['previous count'].to_f
    end

    stats.each do |name, stat|
      ModelStat.create_or_update_by_name!(name, :count => stat['updated count'])
    end

    stats.inspect
  end

  # mailer template function
  def import_report(subject, content)
    @subject = subject
    @body["content"] = content
    @recipients = 'philippe.bourgau@free.fr'
    @from = ''
    @sent_on = Time.now
    @headers = {}
  end

end