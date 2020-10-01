# frozen_string_literal: true

require 'spec_helper'

# class CommandLineDouble
#   def self.output(message:)

#   end
# end

# TODO: make sure these test don't send any external requests
describe Interface::CommandLine do
  subject { described_class }
  let(:message) { 'Frozen string literals by default in Ruby 3.0' }
  it { should respond_to(:output) }

  describe '#output' do
    subject { described_class.output(message) }
    it 'should print the message to standard output' do
      expect { subject }.to output("#{message}\n").to_stdout
    end
    xit 'should send a message to the Object responsible'
  end
end
