# frozen_string_literal: true

require_relative 'board'

module Integrations
  module Trello
    def self.get_tasks
      [Integrations::Trello::Board.get]
    end
  end
end
