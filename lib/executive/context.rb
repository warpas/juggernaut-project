require_relative "exporter"
require_relative "reporter"

module Executive
  def self.generate_weekly_work_report
    Executive::Reporter.generate_weekly_work_report
  end

  def self.send_activities_to_calendar
    # TODO: get entries from Activities::DayLog.entries, then pass them to
    Executive::Exporter.need_a_good_name_for_this_but_now_its_publish_entries
  end

  def self.export_daily_trends_datapoints
    Executive::Exporter.daily_trends_datapoints
  end
end
