module Toggl
  require_relative "../requests"
  require_relative "auth"

  class TimeEntry
    def initialize(project_id:, start: Time.now.to_s)
      @project_id = project_id
      @request_adapter = Requests::Adapter.new
    end

    def save
      response = @request_adapter.post_request(time_entries_url, headers, body)
      response_body = JSON.parse(response[:body])
      puts response
      puts response_body
      response
    end

    def split
    end

    private

    attr_reader :project_id

    def time_entries_url
      "https://www.toggl.com/api/v8/time_entries"
    end

    def headers
      Toggl::Auth.headers
    end

    def body
      "{\"time_entry\":{\"description\":\"Test timer\",\"tags\":[\"work\"],\"duration\":1200,\"start\":\"2020-07-03T17:58:58.000Z\",\"pid\":#{project_id},\"created_with\":\"#{app_name}\"}}"
    end

    def app_name
      "Juggernaut"
    end
  end
end
