require_relative 'report'

module LegacyToggl
  def self.report_details(date:)
    Toggl::Report.new(@start_date).report_details
  end
end
