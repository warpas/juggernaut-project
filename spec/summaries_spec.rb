require "spec_helper"

# TODO: everything here needs better names
# TODO: everything here needs to be implemented. For now it's an exercise in public interface design
describe Summaries::Daily do
  subject { described_class }
  let(:friday) { Date.parse("2020-07-17") }

  describe "#build_trends_for" do
    it "should generate a trend data row based on Time Log data for the day" do
      expect(subject.build_trends_for(date: friday)).to eq("1 hours, 0 minutes and 0 seconds")
    end
  end
end
