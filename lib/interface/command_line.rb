# frozen_string_literal: true

require 'date'

module Interface
  class CommandLineWithoutContext
    def initialize(args: ARGV)
      @runtime_args = args
    end

    def get_runtime_date(default: Date.today)
      date = default.to_s
      @runtime_args.each do |cl_argument|
        split_params = cl_argument.split('=')
        date = split_params.last if split_params.first == '--date' && split_params.length == 2
      end
      Date.parse(date)
    end

    def get_runtime_argument(name: 'argument', default: 'default')
      argument = default
      @runtime_args.each do |cl_argument|
        split_params = cl_argument.split('=')
        argument = split_params.last if split_params.first == "--#{name}" && split_params.length == 2
      end
      argument
    end

    def log_output(string)
      puts string
    end

    def get_input
      gets
    end
  end
end
