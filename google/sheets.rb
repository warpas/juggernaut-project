module Google
  require "google/apis/sheets_v4"
  require "googleauth"
  require "googleauth/stores/file_token_store"
  require "fileutils"
  require "json"

  class Sheets
    OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
    SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

    def get_json_from_file(file_path)
      file = File.read(file_path)
      JSON.parse(file)
    end

    def initialize(config_file:, token_file:, file_id:)
      @config_file = config_file || "credentials"
      @CREDENTIALS_PATH = "google/#{@config_file}.secret.json".freeze
      @config = get_json_from_file(@CREDENTIALS_PATH)
      @TOKEN_PATH = "google/#{token_file}.secret.yaml".freeze
      @APPLICATION_NAME = @config["application"]["name"]
      @spreadsheet_id = @config["sheets"][file_id]
      @service = Google::Apis::SheetsV4::SheetsService.new
      @service.client_options.application_name = @APPLICATION_NAME
      @service.authorization = authorize
    end

    def get_spreadsheet_values(range:)
      response = @service.get_spreadsheet_values @spreadsheet_id, range
      puts "No data found." if response.values.empty?
      response.values.each do |row|
        row.each do |cell|
          print cell + ', '
        end
        puts "\n"
      end
    end

    private

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
  end
end
