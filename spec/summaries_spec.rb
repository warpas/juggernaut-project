require "spec_helper"

# TODO: everything here needs better names
# TODO: everything here needs to be implemented. For now it's an exercise in public interface design
describe Summaries::Daily::Trends do
  subject { described_class }

  let(:before_logging) { Date.parse("2019-07-17") }
  let(:friday) { Date.parse("2020-07-17") }
  let(:empty_trends) { [["2019-07-17", "0", "0", "0", "0", "0", "0", "0", "0"]] }
  let(:trends) { [["2020-07-17", "146", "0", "149", "149", "296", "2", "543", "1"]] }
  let(:todays_trends) { [[Date.today.to_s, "0", "0", "0", "0", "0", "0", "0", "0"]] }
  let(:summary_report) { ReportFixture.summary }
  let(:detailed_report) { ReportFixture.detailed }

  describe "#build" do
    it "should generate a trend data row based on Time Log data for the day" do
      expect(subject.new(cumulative: summary_report, detailed: detailed_report).build(date: friday)).to eq(trends)
    end

    it "should return an trends row for today if no date is given" do
      expect(subject.new.build).to eq(todays_trends)
    end

    it "should return an empty trends row if there was no data on the date given" do
      expect(subject.new.build(date: before_logging)).to eq(empty_trends)
    end
  end
end
