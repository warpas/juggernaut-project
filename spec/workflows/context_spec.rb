require "spec_helper"

describe Workflows::Context do
  subject { described_class }

  describe "#run_weekly_workflow" do
    it "should respond to the 'run_weekly_workflow' message" do
      expect(subject).to respond_to(:run_weekly_workflow)
    end

    xit "should send a message to the Weekly workflow"
  end

  describe "#run_daily_workflow" do
    it "should respond to the 'run_weekly_workflow' message" do
      expect(subject).to respond_to(:run_daily_workflow)
    end

    xit "should send a message to the Daily workflow"
  end
end
