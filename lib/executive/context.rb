require_relative "exporter"
require_relative "reporter"

module Executive
  def self.generate_weekly_work_report
    Executive::Reporter.generate_weekly_work_report
  end

  def self.send_activities_to_calendar
    Executive::Exporter.need_a_good_name_for_this_but_now_its_publish_entries
  end
end
