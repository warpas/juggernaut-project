# frozen_string_literal: true

require_relative 'command_line/context'

module Interface
  def self.output(message:, interface: Interface::CommandLine)
    interface.output(message)
  end

  def self.fetch_params(params:, interface: Interface::CommandLine)
    interface.fetch_params(params)
  end
end
