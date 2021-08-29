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
      cards = board.fetch_cards(list_name: 'In progress')
      cards.each do |card|
        array.push(card)
      end
      array
    end

    def self.list_tasks_in(column_name: 'In progress')
      board = Integrations::Trello::Board.get(id: 'important_progress_board_id')
      cards = board.fetch_cards(list_name: column_name)
      array = []
      cards.each do |card|
        array.push(card)
      end
      array
    end

    def self.create_card
      board = Integrations::Trello::Board.get(id: 'important_progress_board_id')
      return_value = board.add_card_to_list(list_name: "Dependencies (waiting)")
      return_value
    end
  end
end
