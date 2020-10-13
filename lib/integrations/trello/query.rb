# frozen_string_literal: true

require_relative '../../requests'
require_relative 'config'

module Integrations
  module Trello
    class Query
      def initialize
        @request_adapter = Requests::Adapter.new
        @config = Integrations::Trello::Config.new
      end

      def run(entity:, id:)
        request_path = build_path(entity: entity, query_id: id)
        response = @request_adapter.get_request(request_path, request_headers)
        formatted_response = format_json(response)
        { name: formatted_response['name'] }
      end

      private

      attr_reader :config

      def build_path(entity:, query_id:)
        "https://api.trello.com/1/#{query_structure(entity, query_id)}?#{auth_params}"
      end

      def request_headers
        [{ key: 'Accept', value: 'application/json' }]
      end

      def auth_params
        @config.auth
      end

      def query_structure(entity, entity_id)
        @config.fetch_url_structure(entity: entity, id: entity_id)
      end

      def format_json(response)
        status, body = response.values_at(:status, :body)
        return [] if status != 200

        JSON.parse(body)
      end
    end
  end
end
