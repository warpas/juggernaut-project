# frozen_string_literal: true

require 'spec_helper'

class InterfaceDouble
  def self.output(message:); end
end

# TODO: make sure these test don't send any external requests
describe Interface do
  subject { described_class }
  let(:message) { 'Frozen string literals by default in Ruby 3.0' }
  let(:double_message) { 'output message' }
  let(:interface_double) { double('Interface Double', output: double_message) }

  it { should respond_to(:output) }

  describe '#output' do
    subject { described_class.output(message: message, interface: interface_double) }
    it { should equal(double_message) }

    xit 'should send a message to the Object responsible'
  end
end
