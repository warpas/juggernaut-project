require "spec_helper"

# TODO: make sure these test don't send any external requests
describe Toggl::Report do
  # RSpec.describe Toggl::Connection do
  subject { described_class.new(date) }
  let(:date) { "2020-04-18" }

  xit "should" do
    expect(subject.start_date).to equal(date)
  end
end
