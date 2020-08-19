require "spec_helper"

describe Executive do
  subject { described_class }

  describe "#generate_weekly_work_report" do
    it { should respond_to(:generate_weekly_work_report) }

    xit "should send a message to the Object responsible"
  end

  describe "#send_activities_to_calendar" do
    it { should respond_to(:send_activities_to_calendar) }

    xit "should send a message to the Object responsible"
  end
end
