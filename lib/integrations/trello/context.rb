# frozen_string_literal: true

require_relative 'board'

module Integrations
  module Trello
    def self.get_tasks
      board = Integrations::Trello::Board.get(id: 'important_progress_board_id')
      array =
        [
          Integrations::Trello::Board.get,
          board
        ]
      cards = board.fetch_cards(list: 'In progress')
      cards.each do |card|
        array.push(card)
      end
      array
    end
  end
end
