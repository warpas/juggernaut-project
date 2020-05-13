class CommandLine
  def self.get_date_from_command_line(cl_args)
    date = ""
    cl_args.each do |cl_argument|
      split_params = cl_argument.split("=")
      if split_params.first == "--date" && split_params.length == 2
        date = split_params.last
      end
    end
    date
  end
end
