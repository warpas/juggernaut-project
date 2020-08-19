require_relative "daily_trends_report"
require_relative "work_time_reporter"
require_relative "../toggl/report"

module Analysis
  def self.build_daily_trends_report(date:)
    toggl = Toggl::Report.new(date)

    Analysis::DailyTrendsReport.new(
      cumulative: toggl.report_summary,
      detailed: toggl.report_details
    ).build(date: date)
  end

  def self.answer_how_much_work_today
    Analysis::WorkTimeReporter.build_report_for_today
  end
end
