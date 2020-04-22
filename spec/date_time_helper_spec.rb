require "spec_helper"

describe DateTimeHelper do
  subject { described_class }
  let(:one_hour_in_milliseconds_string) { "3600000" }
  let(:over_117_hours) { 423_443_341 }
  let(:april) { Time.parse("2020-04-22 10:12:53") }

  describe "#readable_duration" do
    it "should successfully parse string values to human readable format" do
      expect(subject.readable_duration(one_hour_in_milliseconds_string)).to eq("1 hours, 0 minutes and 0 seconds")
    end
    it "should successfully parse integer values to human readable format" do
      expect(subject.readable_duration(one_hour_in_milliseconds_string.to_i)).to eq("1 hours, 0 minutes and 0 seconds")
    end
    it "should successfully parse durations over 24 hours" do
      expect(subject.readable_duration(over_117_hours)).to eq("117 hours, 37 minutes and 23 seconds")
    end
    it "should return 0s for nonsense strings" do
      expect(subject.readable_duration("asfdfs")).to eq("0 hours, 0 minutes and 0 seconds")
    end
  end

  describe "#formatted_date" do
    it "shoud successfully parse Time instance to YYYY-mm-dd format" do
      expect(subject.formatted_date(april)).to eq("2020-4-22")
    end
    # TODO: add unhappy path
  end
end
