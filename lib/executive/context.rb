# frozen_string_literal: true

require_relative '../analysis/context'
require_relative 'exporter'
require_relative 'reporter'

module Executive
  def self.generate_weekly_work_report
    Executive::Reporter.generate_weekly_work_report
  end

  def self.send_activities_to_calendar
    # TODO: get entries from Activities::DayLog.entries, then pass them to
    Executive::Exporter.publish_entries_in_calendar
  end

  def self.export_trends_datapoint_for_today
    Executive::Exporter.daily_trends_datapoints
  end
end
