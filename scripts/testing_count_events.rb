# require_relative '../lib/google/calendar'
require_relative 'invoices/logic/legacy'
require_relative 'invoices/config/default'

OldInvoice.new(config: DefaultConfig.new).run_script
