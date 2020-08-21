require "date"

module Interface
  class CommandLine
    def initialize(args: [])
      @runtime_args = args
    end

    def get_runtime_date(default: Date.today)
      date = default.to_s
      @runtime_args.each do |cl_argument|
        split_params = cl_argument.split("=")
        if split_params.first == "--date" && split_params.length == 2
          date = split_params.last
        end
      end
      Date.parse(date)
    end

    def get_runtime_argument(name: "argument", default: "default")
      argument = default
      @runtime_args.each do |cl_argument|
        split_params = cl_argument.split("=")
        if split_params.first == "--#{name}" && split_params.length == 2
          argument = split_params.last
        end
      end
      argument
    end

    def self.log(string)
      puts string
    end
  end
end
