module Google
  require "google/apis/calendar_v3"
  require "googleauth"
  require "googleauth/stores/file_token_store"
  require "date"
  require "fileutils"
  require "json"

  class Calendar
    # TODO: Design a clear and minimal interface.
    # TODO: Add unit tests.

    OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze

    # The file token.secret.yaml stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

    def get_json_from_file(file_path)
      file = File.read(file_path)
      JSON.parse(file)
    end

    def initialize(config_file:, token_file:, calendar_name:)
      @config_file = config_file || "credentials"
      @CREDENTIALS_PATH = "google/#{@config_file}.secret.json".freeze
      @config = get_json_from_file(@CREDENTIALS_PATH)
      @TOKEN_PATH = "google/#{token_file}.secret.yaml".freeze
      @APPLICATION_NAME = @config["application"]["name"]
      # TODO: .empty? doesn't cut it anymore. Replace it for this condition to work
      @calendar_id = @config["calendars"][calendar_name].empty? ? "primary" : @config["calendars"][calendar_name]
      @service = Google::Apis::CalendarV3::CalendarService.new
      @service.client_options.application_name = @APPLICATION_NAME
      @service.authorization = authorize
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
      entry_details[:calendars_list].each do |calendar_name|
        calendar_id =
          if @config["calendars"].has_key?(calendar_name)
            @config["calendars"][calendar_name]
          else
            @calendar_id
          end
        result = @service.insert_event(calendar_id, event)
        puts "Event created: #{result.html_link}"
      end

      if entry_details[:calendars_list].empty?
        puts "Calendar list is empty"
        result = @service.insert_event(calendar_id, event)
        puts "Event created: #{result.html_link}"
      end
    end

    def get_colours
      # GET https://www.googleapis.com/calendar/v3/colors
      @service.get_color
    end

    private

    attr_reader :calendar_id, :config_file

    ##
    # Ensure valid credentials, either by restoring from the saved credentials
    # files or intitiating an OAuth2 authorization. If authorization is required,
    # the user's default browser will be launched to approve the request.
    #
    # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
    def authorize
      client_id = Google::Auth::ClientId.from_file @CREDENTIALS_PATH
      token_store = Google::Auth::Stores::FileTokenStore.new file: @TOKEN_PATH
      authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
      user_id = "default"
      credentials = authorizer.get_credentials user_id
      if credentials.nil?
        url = authorizer.get_authorization_url base_url: OOB_URI
        puts "Open the following URL in the browser and enter the " \
             "resulting code after authorization:\n" + url
        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI
        )
      end
      credentials
    end

    def query_successful?
      puts "Not implemented yet."
      false
    end
  end
end
