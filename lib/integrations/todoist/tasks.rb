# frozen_string_literal: true

require_relative '../../requests'
require 'json'

module Integrations
  module Todoist
    class Task
      attr_reader :description

      def initialize(task_json)
        @description = task_json['content']
        @url = task_json['url']
      end
    end

    class Query
      def initialize
        @request_adapter = Requests::Adapter.new
      end

      def run(entity:, label:)
        request_path = build_path(entity: entity, label: label)
        response = @request_adapter.get_request(request_path, request_headers)
        formatted_response = format_json(response)
        get_task_list(formatted_response)
      end

      private

      def build_path(entity:, label:)
        "https://api.todoist.com/rest/v1/#{entity}\?filter\=@#{label}"
      end

      def request_headers
        [{ key: 'Authorization', value: "Bearer #{api_token}" }]
      end

      def format_json(response)
        status, body = response.values_at(:status, :body)
        return empty_response if status != 200

        JSON.parse(body)
      end

      def api_token
        config = get_json_from_file('lib/integrations/todoist/credentials.secret.json')
        config['token']
      end

      def get_json_from_file(file_path)
        # TODO: this should be in Interface::File context
        file = File.read(file_path)
        JSON.parse(file)
      end

      def empty_response
        []
      end

      def get_task_list(json_object)
        json_object.map do |elem|
          Task.new(elem)
        end
      end
    end

    class Tasks
      attr_reader :list

      def initialize(label: 'Label', todoist_query: Integrations::Todoist::Query.new)
        @list = todoist_query.run(entity: 'tasks', label: label)
      end

      def self.filter_by(label:)
        new(label: label).list
      end
    end
  end
end
