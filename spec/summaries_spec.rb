require "spec_helper"

# TODO: everything here needs better names
# TODO: everything here needs to be implemented. For now it's an exercise in public interface design
describe Summaries::Daily do
  subject { described_class }
  let(:friday) { Date.parse("2020-07-17") }

  describe "#build_trend_summary" do
    it "should generate a trend data row based on Time Log data for the day" do
    end
  end
end
