require_relative "google/sheets"

test_sheet = Google::Sheets.new(config_file: "dw_credentials", token_file: "dws_token", file_id: "test")
test_sheet.get_spreadsheet_values(range: "Sheet1!A1:F14")

accounting_doc = Google::Sheets.new(config_file: "dw_credentials", token_file: "dws_token", file_id: "accounting")
accounting_doc.get_spreadsheet_values(range: "Spendings!A1:K84")
