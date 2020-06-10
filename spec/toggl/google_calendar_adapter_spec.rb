require "spec_helper"

describe Toggl::GoogleCalendarAdapter do
  subject { described_class.new }
  let(:date) { Date.parse("2020-06-07") }
  let(:empty_report) { {"total_grand" => 0, "data" => []} }
  let(:full_work_week_report) { {"total_grand" => 144_816_000, "data" => []} }

  describe "#build_entry_list_from" do
  end

  describe "#build_weekly_summary" do
    it "return an array with one element" do
      expect(subject.build_weekly_summary(report: empty_report, report_day: date).count).to eq(1)
    end
    it "should handle empty reports gracefully" do
      expect(subject.build_weekly_summary(report: empty_report, report_day: date).first).to include(
        description: "⏱Total time logged last week:\n0 hours, 0 minutes and 0 seconds\n"
      )
    end
    it "should have the right title" do
      expect(subject.build_weekly_summary(report: empty_report, report_day: date).first).to include(
        title: "Last week summary"
      )
    end

    it "should format time into hours/minutes/seconds" do
      expect(subject.build_weekly_summary(report: full_work_week_report, report_day: date).first).to include(
        description: "⏱Total time logged last week:\n40 hours, 13 minutes and 36 seconds\n"
      )
    end
  end

  describe "#build_weekly_summary_from" do
  end

  describe "#build_daily_summary_from" do
  end
end
