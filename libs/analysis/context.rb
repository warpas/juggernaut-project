require_relative "daily_trends_report"

module Analysis
  def self.build_daily_trends_report(date:)
    toggl = Toggl::Report.new(date)

    Analysis::DailyTrendsReport.new(
      cumulative: toggl.report_summary,
      detailed: toggl.report_details
    ).build(date: date)
  end

  def self.answer_how_much_work_today
  end
end
