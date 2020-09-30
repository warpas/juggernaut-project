# frozen_string_literal: true

class CommandLineOldest
  def self.get_date_from_command_line(cl_args)
    date = ''
    cl_args.each do |cl_argument|
      split_params = cl_argument.split('=')
      date = split_params.last if split_params.first == '--date' && split_params.length == 2
    end
    date
  end
end
