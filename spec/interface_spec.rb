require "spec_helper"

describe Interface::CommandLine do
  subject { described_class }

  let(:friday) { Date.parse("2020-07-24") }
  let(:monday) { Date.parse("2020-07-27") }

  describe "#get_runtime_date" do
    it "should return today's date by default" do
      expect(subject.new.get_runtime_date).to eq(Date.today)
    end

    it "should accept the default key argument" do
      expect(subject.new.get_runtime_date(default: friday)).to eq(friday)
    end

    it "should prefer the command line argument over the default" do
      expect(subject.new(args: ["--date=2020-07-27"]).get_runtime_date(default: friday)).to eq(monday)
    end
  end
end
