# frozen_string_literal: true

require_relative '../../requests'
require 'json'

module Integrations
  module Trello
    class Query
      def initialize
        @request_adapter = Requests::Adapter.new
      end

      def run(entity:, id:)
        request_path = build_path(entity: entity, query_id: id)
        response = @request_adapter.get_request(request_path, request_headers)
        formatted_response = format_json(response)
        { name: formatted_response['name'] }
      end

      def build_path(entity:, query_id:)
        "https://api.trello.com/1/#{entity}/#{query_id}?key=#{api_key}&token=#{api_token}"
      end

      def request_headers
        [{ key: 'Accept', value: 'application/json' }]
      end

      def get_json_from_file(file_path)
        # TODO: this should be in Interface::File context
        file = File.read(file_path)
        JSON.parse(file)
      end

      def api_key
        config = get_json_from_file('lib/integrations/trello/credentials.secret.json')
        config['trello']['key']
      end

      def api_token
        config = get_json_from_file('lib/integrations/trello/credentials.secret.json')
        config['trello']['token']
      end

      def format_json(response)
        status, body = response.values_at(:status, :body)
        return [] if status != 200

        JSON.parse(body)
      end
    end

    class Board
      # TODO: remove the 'board' attribute
      attr_reader :name, :url, :board, :description

      def initialize(id: 'Some_id', trello_query: Integrations::Trello::Query.new)
        @board = trello_query.run(entity: 'boards', id: example_id)
        @description = @board[:name]
      end

      def self.get(id: 'Some_id')
        new(id: id)
      end

      def get_json_from_file(file_path)
        # TODO: this should be in Interface::File context
        file = File.read(file_path)
        JSON.parse(file)
      end

      def example_id
        # TODO: configuration's getting messy again. Clean it up
        config = get_json_from_file('lib/integrations/trello/credentials.secret.json')
        config['trello']['example_board_id']
      end
    end
  end
end
