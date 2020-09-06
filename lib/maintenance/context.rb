require_relative "../interface/command_line"

module Maintenance
  class Logger
    def initialize(interface:)
      @interface = interface
    end

    def self.log_info(message:)
      cli = Interface::CommandLine.new
      new(interface: cli).info(message: message)
    end

    def info(message:)
      @interface.log_output(message)
    end

    private

    attr_reader :log_output
  end
end
