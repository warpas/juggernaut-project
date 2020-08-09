module Toggl
  require_relative "../requests"
  require_relative "auth"

  class TimeEntry
    def initialize(entry) # project_id:, start: Time.now.to_s)
      @project_id = entry["pid"]
      @entry = entry
      @entry["created_with"] = app_name
      @entry["duration"] = entry["dur"] / 1000

      # TODO: separate adapter from TimeEntry object
      @request_adapter = Requests::Adapter.new
    end

    def as_json
      JSON.generate({"time_entry" => @entry})
    end

    def save
      response = @request_adapter.post_request(time_entries_url, headers, as_json)
      response_body = JSON.parse(response[:body])
      response
    end

    def split(breakpoint:)
      @entry
      # TODO: change it to an instance method. Add TimeEntry.find(id)
      before_breakpoint = DateTimeHelper.seconds_before(breakpoint, 70)
      after_breakpoint = DateTimeHelper.seconds_after(breakpoint, 70)
      first_duration = TimeEntry.calculate_duration(scope_start: @entry["start"], scope_end: before_breakpoint.to_s)
      last_duration = TimeEntry.calculate_duration(scope_start: after_breakpoint.to_s, scope_end: @entry["end"])

      copy_with_changes(change: {"end" => before_breakpoint, "dur" => first_duration})
      copy_with_changes(change: {"start" => after_breakpoint, "dur" => last_duration})

      remove
    end

    # TODO: take ID as an argument
    def get_details
      url = "#{time_entries_url}/#{@entry["id"]}"
      @request_adapter.get_request(url, headers)
      # puts "response = #{response}"
    end

    def remove
      # TODO: change it to an instance method
      puts "\nentry_to_remove = #{@entry}"
      url = "#{time_entries_url}/#{@entry["id"]}"
      response = @request_adapter.delete_request(url, headers)
      puts "✂️  Entry removed successfully!" if response[:status] == 200
    end

    private

    attr_reader :project_id

    # TODO: Move to DateTimeHelper
    def self.calculate_duration(scope_start:, scope_end:)
      ((DateTime.parse(scope_end).to_time - DateTime.parse(scope_start).to_time) * 1000).to_i
    end

    def copy_with_changes(change:)
      # TODO: change it to an instance method
      filtered_entry = @entry.select { |key, _|
        TimeEntry.params_whitelist.include?(key)
      }

      change.each do |key, value|
        filtered_entry[key] = value
      end

      response = TimeEntry.new(filtered_entry).save
      puts "📑  Copy created successfully!" if response[:status] == 200
    end

    def time_entries_url
      "https://www.toggl.com/api/v8/time_entries"
    end

    def headers
      Toggl::Auth.headers
    end

    def app_name
      "Juggernaut"
    end

    def self.params_whitelist
      [
        "pid",
        "tid",
        "uid",
        "description",
        "start",
        "end",
        "updated",
        "dur",
        "user",
        "use_stop",
        "client",
        "project",
        "project_color",
        "project_hex_color",
        "task",
        "cur",
        "tags"
      ]
    end
  end
end
