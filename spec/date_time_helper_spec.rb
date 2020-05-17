require "spec_helper"

describe DateTimeHelper do
  subject { described_class }
  let(:one_hour_in_milliseconds_string) { "3600000" }
  let(:over_117_hours) { 423_443_341 }
  let(:april) { Time.parse("2020-04-22 10:12:53") }
  let(:monday) { Date.parse("2020-05-11") }
  let(:friday) { Date.parse("2020-05-15") }
  let(:sunday) { Date.parse("2020-05-17") }

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

  describe "#get_week_start" do
    it "should return a date that is a Moday" do
      expect(subject.get_week_start(friday).cwday).to eq(1)
    end

    it "should return a the same day if the argument is already a Monday" do
      expect(subject.get_week_start(monday)).to eq(monday)
    end

    it "should return the previous Monday if the argument is a Sunday" do
      expect(subject.get_week_start(sunday)).to eq(monday)
    end
  end

  describe "#get_next_closest_sunday" do
    it "should return a date that is a Sunday" do
      expect(subject.get_next_closest_sunday(friday).cwday).to eq(7)
    end

    it "should return a the same day if the argument is already a Sunday" do
      expect(subject.get_next_closest_sunday(sunday)).to eq(sunday)
    end

    it "should return a the next Sunday if the argument is a Monday" do
      expect(subject.get_next_closest_sunday(monday)).to eq(sunday)
    end
  end
end
