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

    def get_json_from_file(file_path)
      file = File.read(file_path)
      JSON.parse(file)
    end

    def initialize(config_file:, token_file:, calendar_name:)
      # TODO: replace the following line by first argument default value
      @config_file = config_file || "credentials"
      credentials_path = "google/#{@config_file}.secret.json".freeze
      @config = get_json_from_file(credentials_path)
      # TODO: .empty? doesn't cut it anymore. Replace it for this condition to work
      @calendar_id = @config["calendars"][calendar_name].empty? ? "primary" : @config["calendars"][calendar_name]

      @service = Google::Apis::CalendarV3::CalendarService.new
      app_name = @config["application"]["name"]
      @service.client_options.application_name = app_name
      token_path = "google/#{token_file}.secret.yaml".freeze
      @service.authorization = authorize(credentials_path: credentials_path, token_path: token_path)
    end

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
      response.items
    end

    def add_list_of_entries(entry_list)
      entry_list.each do |entry|
        add_entry(entry)
      end
    end

    def add_entry_without_duplicates(entry_details)
    end

    def add_entry(entry_details)
      # TODO: add entry if it wasn't added already. Handle duplicates.
      puts "\ninside Google::Calendar.add_entry/1"
      puts "Argument received: #{entry_details}"
      # TODO: maybe send POST through requests.rb to https://www.googleapis.com/calendar/v3/calendars/calendarId/events

      event = Google::Apis::CalendarV3::Event.new(
        start: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: entry_details[:start]
        ),
        end: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: entry_details[:end]
        ),
        description: entry_details[:description],
        summary: entry_details[:title]
        # color_id: entry_details[:colorId],
      )
      entry_details[:calendars_list]&.each do |calendar_name|
        calendar_id =
          if @config["calendars"].has_key?(calendar_name)
            @config["calendars"][calendar_name]
          else
            @calendar_id
          end
        result = @service.insert_event(calendar_id, event)
        puts "Event created: #{result.html_link}"
      end

      if entry_details[:calendars_list].nil? || entry_details[:calendars_list].empty?
        puts "Calendar list is empty"
        result = @service.insert_event(calendar_id, event)
        puts "Event created: #{result.html_link}"
      end
    end

    def get_colours
      # GET https://www.googleapis.com/calendar/v3/colors
      @service.get_color
    end

    def copy_to_calendar(date:, destination:, color_coding:)
      fetch_events(date).each do |event|
        entry = {
          start: event.start.date_time,
          end: event.end.date_time,
          title: event.summary
        }
        if color_coding != "" && event.color_id == color_coding
          destination.add_entry(entry)
        elsif color_coding == ""
          destination.add_entry(entry)
        end
      end
    end

    # def fetch_single_event()
    # def remove_event()

    private

    attr_reader :calendar_id, :config_file

    OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
    SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR
    def authorize(credentials_path:, token_path:)
      scope = Google::Apis::CalendarV3::AUTH_CALENDAR
      Google::AuthWrapper.authorize(credentials_path: credentials_path, token_path: token_path, scope: scope)
    end
  end
end
