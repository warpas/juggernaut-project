require "spec_helper"

describe Activities::DayLog do
  subject { described_class.new(date: friday) }

  let(:friday) { Date.parse("2020-08-28") }

  it { should respond_to(:date) }

  describe "#date" do
    it "should return the date for the log" do
      expect(subject.date).to eq(friday)
    end
  end
end
