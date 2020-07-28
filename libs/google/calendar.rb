module Google
  require_relative "auth_wrapper"
  require "google/apis/calendar_v3"
  require "googleauth"
  require "googleauth/stores/file_token_store"
  require "date"
  require "fileutils"
  require "json"

  class Calendar
    # TODO: Design a clear and minimal interface.
    # TODO: Add unit tests.

    def initialize(
      config_file: "libs/google/calendar/credentials.secret.json",
      token_file: "libs/google/calendar/token.secret.yaml",
      calendar_name: "primary"
    )
      @config = get_json_from_file(config_file)
      @name = calendar_name
      @calendar_id = get_calendar_id_for(calendar_name)

      @service = Google::Apis::CalendarV3::CalendarService.new
      @service.client_options.application_name = application_name
      @service.authorization = authorize(credentials_path: config_file, token_path: token_file)
    end

    attr_reader :name

    def fetch_next_events(count)
      # Fetch the next 'count' events for the user
      optional_params =
        {
          max_results: count,
          single_events: true,
          order_by: "startTime",
          time_min: DateTime.now.rfc3339
        }
      response = @service.list_events(calendar_id, optional_params)
      puts "Upcoming events:"
      puts "No upcoming events found" if response.items.empty?
      response.items.each do |event|
        start = event.start.date || event.start.date_time
        puts "- #{event.summary} (#{start})"
      end
      response.items
    end

    def fetch_events(date)
      optional_params =
        {
          single_events: true,
          # order_by: "startTime",
          time_min: "#{date}T00:00:01+02:00",
          time_max: "#{date}T23:59:59+02:00"
        }
      response = @service.list_events(calendar_id, optional_params)
      # TODO: line above warning: Using the last argument as keyword parameters is deprecated; maybe ** should be added to the call
      response.items
    end

    def fetch_events_from(date, cal_id)
      optional_params =
        {
          single_events: true,
          # order_by: "startTime",
          time_min: "#{date}T00:00:01+02:00",
          time_max: "#{date}T23:59:59+02:00"
        }
      response = @service.list_events(cal_id, optional_params)
      response.items
    end

    def fetch_all_events(cal_id)
      @service.list_events(cal_id)
    end

    def insert_calendar_event(event, cal_id = @calendar_id)
      result = @service.insert_event(cal_id, event)
      puts "✅  Event created: #{result.html_link}"
    rescue => _e
      puts "Duplicate event found"
    end

    def add_list_of_entries(entry_list)
      entry_list.each do |entry|
        add_entry(entry)
      end
    end

    def add_list_of_entries_no_duplicates(entry_list)
      entry_list.each do |entry|
        add_entry_without_duplicates(entry)
      end
    end

    # TODO: make sure entry_details.start and entry_details.end are DateTime
    def add_entry_without_duplicates(entry_details)
      start_date = entry_details[:start].strftime
      date = start_date.split("T").first
      output_calendar_list = sanitize_calendar_list(entry_details[:calendars_list])
      output_calendar_list.each do |calendar|
        day_events = fetch_events_from(date, calendar)
        if day_events.count == 0
          add_entry(entry_details)
        else
          found = false
          # TODO: use include? instead
          day_events.each do |event|
            if (event.start.date_time.to_s == entry_details[:start].strftime) &&
                (event.summary == entry_details[:title]) &&
                (event.description == entry_details[:description])
              found = true
            end
          end
          add_entry(entry_details) unless found
        end
        puts "Naught but duplicates and tumbleweeds found." if found
      end
    end

    # def add_or_update_entry(entry_details)

    def add_entry(entry_details)
      puts "\ninside Google::Calendar.add_entry/1"
      puts "Argument received: #{entry_details}"
      event = build_calendar_event(entry_details)
      output_calendar_list = sanitize_calendar_list(entry_details[:calendars_list])
      output_calendar_list.each do |calendar|
        # TODO: use insert_event function
        result = @service.insert_event(calendar, event)
        puts "✅  Event created: #{result.html_link}"
      end
    end

    def get_colours
      # GET https://www.googleapis.com/calendar/v3/colors
      @service.get_color
    end

    def list_calendars
      response = @service.list_calendar_lists.to_json
      json_list = JSON.parse(response)["items"]
      json_list.map do |calendar_item|
        {
          name: calendar_item["summary"],
          id: calendar_item["id"]
        }
      end
    end

    def copy_to_calendar(date:, destination:, color_coding:)
      fetch_events(date).each do |event|
        entry = {
          start: event.start.date_time,
          end: event.end.date_time,
          title: event.summary
        }
        if color_coding != "" && event.color_id == color_coding
          destination.add_entry_without_duplicates(entry) unless entry[:start].nil?
        elsif color_coding == ""
          destination.add_entry_without_duplicates(entry) unless entry[:start].nil?
        end
      end
    end

    # def fetch_single_event()
    # def remove_event()

    private

    attr_reader :calendar_id

    def get_json_from_file(file_path)
      file = File.read(file_path)
      JSON.parse(file)
    end

    def authorize(credentials_path:, token_path:)
      scope = Google::Apis::CalendarV3::AUTH_CALENDAR
      Google::AuthWrapper.authorize(credentials_path: credentials_path, token_path: token_path, scope: scope)
    end

    def application_name
      @config["application"]["name"]
    end

    def get_calendar_id_for(calendar_name)
      from_config = @config["calendars"][calendar_name]
      from_config.nil? ? "primary" : from_config
    end

    def build_calendar_event(details)
      Google::Apis::CalendarV3::Event.new(
        start: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: details[:start]
        ),
        end: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: details[:end]
        ),
        description: details[:description],
        summary: details[:title]
        # color_id: details[:colorId],
      )
    end

    def sanitize_calendar_list(calendar_list)
      return [calendar_id] if calendar_list.nil?
      evaluated_list = calendar_list.map { |name| @config["calendars"][name] }
      sanitized_list = evaluated_list.reject { |x| x.nil? }
      sanitized_list.empty? ? [calendar_id] : sanitized_list
    end
  end
end
