module Toggl
  require_relative "../requests"

  class TimeEntry
    def initialize(project_id:, start:)
      @request_adapter = Requests::Adapter.new
    end

    def save
      address = "https://www.toggl.com/api/v8/time_entries"
      body = '{"time_entry":{"description":"Test timer","tags":["work"],"duration":1200,"start":"2020-07-01T07:58:58.000Z","pid":123,"created_with":"curl"}}'
      response = @request_adapter.post_request(address, headers, body)
    end
  end
end
