module Workflows
  class Runner
    def initialize(scripts: [])
      @script_list = scripts
    end

    def start
      iterator = 1
      script_count = @script_list.count
      @script_list.each do |script|
        puts "\n⚙️  Running script number #{iterator} / #{script_count}\n"
        load script
        puts "\n✅  Script number #{iterator} / #{script_count} ran successfully\n"
        iterator += 1
      end
      puts "\n✅  All scripts within the workflow ran successfully!!"
    end

    private

    attr_reader :script_list
  end
end


