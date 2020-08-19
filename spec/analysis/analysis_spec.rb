require "spec_helper"

describe Analysis do
  subject { described_class }

  describe "#build_daily_trends_report" do
    it { should respond_to(:build_daily_trends_report) }

    xit "should send a message to the Object responsible"
  end

  describe "#answer_how_much_work_today" do
    it { should respond_to(:answer_how_much_work_today) }

    xit "should send a message to the Object responsible"
  end
end
