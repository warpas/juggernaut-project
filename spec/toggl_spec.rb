require 'spec_helper'

describe Toggl::Timer do
  subject { described_class.new(date) }
  let(:date) { '2020-04-18' }

  it 'should' do
    expect(subject.start_date).to equal(date)
  end
end
