require "spec_helper"

describe Activities::Category do
  subject { described_class }
  # let(:friday) { Date.parse("2020-07-17") }
  let(:categories_list) { %w[reading writing work games consumption creative sleep exercise] }

  describe "#list" do
    it "should return a list of activity categories" do
      expect(subject.list).to eq(categories_list)
    end
  end
end
