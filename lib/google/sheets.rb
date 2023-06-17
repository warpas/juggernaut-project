# frozen_string_literal: true

module Google
  require_relative 'auth_wrapper'
  require 'google/apis/sheets_v4'
  require 'googleauth'
  require 'googleauth/stores/file_token_store'
  require 'fileutils'
  require 'json'

  class Sheets
    def initialize(
      config_file: 'lib/google/sheets/credentials.secret.json',
      token_file: 'lib/google/sheets/token.secret.yaml',
      file_id:
    )
      @config = get_json_from_file(config_file)
      @spreadsheet_id = assign_spreadsheet_id(file_id)

      @service = Google::Apis::SheetsV4::SheetsService.new
      @service.client_options.application_name = application_name
      @service.authorization = authorize(credentials_path: config_file, token_path: token_file)
    end

    def get_spreadsheet_values(range:)
      response = @service.get_spreadsheet_values spreadsheet_id, range
      puts 'No data found.' if response.values.empty?
      # response.values.each do |row|
      #   row.each do |cell|
      #     print cell + ' | '
      #   end
      #   puts "\n"
      # end
      response
    end

    def get_sheet_values_with_format(sheet:)
      response = @service.get_spreadsheet(spreadsheet_id)
      # response = @service.batch_get_spreadsheet_values(spreadsheet_id, ranges: sheet, value_render_option: "FORMATTED_VALUE")
      puts response.value_ranges.class
    end

    def send_to_sheets(values: [['test']], range: 'Sheet1!B4')
      request_body = Google::Apis::SheetsV4::ValueRange.new(range: range, values: values)
      response = service.update_spreadsheet_value(
        spreadsheet_id,
        range,
        request_body,
        value_input_option: 'USER_ENTERED'
      )
      # puts response.to_json
      response
    end

    def append_trend_datapoint(payload:)
      append_to_sheet(values: payload, range: 'Data!A:I')
    end

    def append_to_sheet(values: [['test']], range: 'Sheet1!B4')
      request_body = Google::Apis::SheetsV4::ValueRange.new(values: values)
      result = service.append_spreadsheet_value(
        spreadsheet_id,
        range,
        request_body,
        value_input_option: 'USER_ENTERED'
      )
      puts "#{result.updates.updated_cells} cells appended."
    end

    def add_sheet_to_spreadsheet(name)
      sheet_properties = Google::Apis::SheetsV4::SheetProperties.new(title: name)
      new_sheet_request = Google::Apis::SheetsV4::AddSheetRequest.new(properties: sheet_properties)
      batch_request = Google::Apis::SheetsV4::Request.new(add_sheet: new_sheet_request)
      request_body = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new(requests: [batch_request])
      begin
        puts "🏗  Adding sheet: #{name} to the spreadsheet  🏗"
        result = service.batch_update_spreadsheet(
          spreadsheet_id,
          request_body)
        rescue Google::Apis::TransmissionError
          puts "🕑  Transmission timed out  🕑"
        rescue Google::Apis::ClientError
          puts "❌  sheet with requested name already exists or spreadsheet not defined, please verify your credentials.secret.json file  ❌"
        else
          puts "✅  Sheet added successfully  ✅"
        ensure
          puts "✅  Script runtime complete  ✅"
      end
    end

    private

    attr_reader :spreadsheet_id, :service

    def get_json_from_file(file_path)
      file = File.read(file_path)
      JSON.parse(file)
    end

    def authorize(credentials_path:, token_path:)
      scope = Google::Apis::SheetsV4::AUTH_SPREADSHEETS
      Google::AuthWrapper.authorize(credentials_path: credentials_path, token_path: token_path, scope: scope)
    end

    def application_name
      @config['application']['name']
    end

    def assign_spreadsheet_id(spreadsheet_name)
      @config['sheets'][spreadsheet_name]
    end
  end
end
