require_relative '../lib/google/calendar'
require_relative '../lib/google/sheets'
require_relative '../scripts/invoices/logic/legacy'

OldInvoice.new(config: DefaultConfig.new).run_script
