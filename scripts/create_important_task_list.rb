# frozen_string_literal: true

require_relative '../lib/integrations/trello/context'

# Executive.export_trends_datapoint_for_today

card_name = 'Nowa karta'
board_url = Integrations::Trello::Board.get(id: 'important_progress_board_id').url
board_name = 'Important progress'
column_name = 'Dependencies (waiting)'

list_response = Integrations::Trello.list_tasks_in(column_name: column_name)
puts "Tasks in column '#{column_name}': #{list_response}"
Integrations::Trello.create_card
