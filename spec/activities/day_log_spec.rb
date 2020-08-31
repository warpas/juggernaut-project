require "spec_helper"

describe Activities::DayLog do
  subject { described_class.new(date: friday) }

  let(:friday) { Date.parse("2020-08-28") }

  it { should respond_to(:date) }
  it { should respond_to(:entries) }

  describe "#date" do
    it "should return the date for the log" do
      expect(subject.date).to eq(friday)
    end
  end

  describe "#entries" do
    it "should return a list of activities logged on that day" do
    end
  end

  xdescribe "#split_midnight_entry" do
  end
end
