module Google
  require "google/apis/calendar_v3"
  require "googleauth"
  require "googleauth/stores/file_token_store"
  require "date"
  require "fileutils"

  class Calendar
    OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
    APPLICATION_NAME = "Toggl Report Importer".freeze
    CREDENTIALS_PATH = "google/credentials.secret.json".freeze

    # The file token.secret.yaml stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    TOKEN_PATH = "google/token.secret.yaml".freeze
    SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

    def initialize(cal_id = 'primary')
      @service = Google::Apis::CalendarV3::CalendarService.new
      @service.client_options.application_name = APPLICATION_NAME
      @service.authorization = authorize

      @calendar_id = cal_id
    end

    def fetch_next_events(count)
      # Fetch the next 'count' events for the user
      response = @service.list_events(calendar_id,
                                    max_results:   count,
                                    single_events: true,
                                    order_by:      "startTime",
                                    time_min:      DateTime.now.rfc3339)
      puts "Upcoming events:"
      puts "No upcoming events found" if response.items.empty?
      response.items.each do |event|
        start = event.start.date || event.start.date_time
        puts "- #{event.summary} (#{start})"
      end
    end

    def add_work_entry(entry_details)
      puts "\ninside Google::Calendar.add_work_entry/1"
      puts "Argument received: #{entry_details}"
      # TODO: maybe send POST through requests.rb to https://www.googleapis.com/calendar/v3/calendars/calendarId/events

      event = Google::Apis::CalendarV3::Event.new(
          start: Google::Apis::CalendarV3::EventDateTime.new(
            date_time: entry_details[:start],
          ),
          end: Google::Apis::CalendarV3::EventDateTime.new(
            date_time: entry_details[:start],
          ),
          description: entry_details[:description],
          summary: entry_details[:title],
      )
      result = @service.insert_event(@calendar_id, event)
      puts "Event created: #{result.html_link}"
    end

    private

    def calendar_id
      @calendar_id
    end

    ##
    # Ensure valid credentials, either by restoring from the saved credentials
    # files or intitiating an OAuth2 authorization. If authorization is required,
    # the user's default browser will be launched to approve the request.
    #
    # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
    def authorize
      client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
      token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
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
      puts 'Not implemented yet.'
      false
    end
  end
end
