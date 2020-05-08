module Google
  require_relative "auth_wrapper"
  require "google/apis/sheets_v4"
  require "googleauth"
  require "googleauth/stores/file_token_store"
  require "fileutils"
  require "json"

  class Sheets
    def get_json_from_file(file_path)
      file = File.read(file_path)
      JSON.parse(file)
    end

    def initialize(config_file: "credentials", token_file: "token", file_id:)
      credentials_path = "google/#{config_file}.secret.json".freeze
      token_path = "google/#{token_file}.secret.yaml".freeze
      @config = get_json_from_file(credentials_path)
      @spreadsheet_id = assign_spreadsheet_id(file_id)

      @service = Google::Apis::SheetsV4::SheetsService.new
      @service.client_options.application_name = application_name
      @service.authorization = authorize(credentials_path: credentials_path, token_path: token_path)
    end

    def get_spreadsheet_values(range:)
      response = @service.get_spreadsheet_values spreadsheet_id, range
      puts "No data found." if response.values.empty?
      response.values.each do |row|
        row.each do |cell|
          print cell + " | "
        end
        puts "\n"
      end
    end

    def send_to_sheets(values:, range: "May_2020!B4")
      request_body = Google::Apis::SheetsV4::ValueRange.new(range: range, values: values)
      response = @service.update_spreadsheet_value(spreadsheet_id, range, request_body, value_input_option: "RAW")
      puts response.to_json
    end

    private

    attr_reader :spreadsheet_id

    def authorize(credentials_path:, token_path:)
      scope = Google::Apis::SheetsV4::AUTH_SPREADSHEETS
      Google::AuthWrapper.authorize(credentials_path: credentials_path, token_path: token_path, scope: scope)
    end

    def application_name
      @config["application"]["name"]
    end

    def assign_spreadsheet_id(spreadsheet_name)
      @config["sheets"][spreadsheet_name]
    end
  end
end
