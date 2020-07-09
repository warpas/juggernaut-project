module Toggl
  require_relative "../requests"
  require_relative "auth"

  class TimeEntry
    def initialize(entry)#project_id:, start: Time.now.to_s)
      @project_id = entry["pid"]
      @entry = entry
      @entry["created_with"] = app_name
      @entry["duration"] = entry["dur"] / 1000
      puts "@entry[duration] #{@entry["duration"]}"

      # TODO: separate adapter from TimeEntry object
      @request_adapter = Requests::Adapter.new
    end

    def as_json
      JSON.generate({"time_entry" => @entry})
    end

    def save
      response = @request_adapter.post_request(time_entries_url, headers, as_json)
      puts response
      response_body = JSON.parse(response[:body])
      puts response_body
      response
    end

    def self.split(entry_to_split:, breakpoint:)
      # TODO: change it to an instance method. Add TimeEntry.find(id)
      breakpoint_end = DateTimeHelper.seconds_before(breakpoint, 70)
      breakpoint_start = DateTimeHelper.seconds_after(breakpoint, 70)
      first_duration = self.calculate_duration(scope_start: entry_to_split["start"], scope_end: breakpoint_end.to_s)
      last_duration = self.calculate_duration(scope_start: breakpoint_start.to_s, scope_end: entry_to_split["end"])

      copy_with_changes(copy: entry_to_split, change: {"end" => breakpoint_end, "dur" => first_duration})
      copy_with_changes(copy: entry_to_split, change: {"start" => breakpoint_start, "dur" => last_duration})

      time_entry_object = TimeEntry.new(entry_to_split)
      time_entry_object.remove
    end

    # TODO: take ID as an argument
    def get_details
      url = "#{time_entries_url}/#{@entry["id"]}"
      response = @request_adapter.get_request(url, headers)
      puts "response = #{response}"
    end

    def remove
      # TODO: change it to an instance method
      puts "\nentry_to_remove = #{@entry}"
      url = "#{time_entries_url}/#{@entry["id"]}"
      response = @request_adapter.delete_request(url, headers)
      puts "response = #{response}"
      puts "Entry removed successfully!" if response[:status] == 200
    end

    private

    attr_reader :project_id

    def self.calculate_duration(scope_start:, scope_end:)
      ((DateTime.parse(scope_end).to_time - DateTime.parse(scope_start).to_time) * 1000).to_i
    end

    def self.copy_with_changes(copy:, change:)
      # TODO: change it to an instance method
      params_whitelist = [
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
        "tags",
      ]
      filtered_entry = copy.select do |key, value|
        params_whitelist.include?(key)
      end

      change.each do |key, value|
        filtered_entry[key] = value
      end
      entry = TimeEntry.new(filtered_entry)
      response = entry.save
      puts "Copy created successfully!" if response[:status] == 200
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
  end
end
