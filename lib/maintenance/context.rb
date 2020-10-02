# frozen_string_literal: true

require_relative '../interface/command_line/context'

module Maintenance
  class Logger
    def initialize(interface:)
      @interface = interface
    end

    def self.log_info(message:)
      cli = Interface::CommandLine
      new(interface: cli).info(message: message)
    end

    def info(message:)
      @interface.output(message)
    end

    private

    attr_reader :log_output
  end
end
