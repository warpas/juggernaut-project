require "spec_helper"

describe Analysis do
  subject { described_class }
  it { should respond_to(:build_daily_trends_report) }
  it { should respond_to(:answer_how_much_work_today) }

  describe "#build_daily_trends_report" do
    xit "should send a message to the Object responsible"
  end

  describe "#answer_how_much_work_today" do
    xit "should send a message to the Object responsible"
  end
end
