module Google
  class Calendar
    def initialize
      @calendar_link = ''
    end

    def add_work_entry(entry_details)
      puts "\ninside Google::Calendar.add_work_entry/1"
      puts "Argument received: #{entry_details}"

      if query_successful?
        puts 'Entry added successfully!'
      else
        puts 'Something went wrong :('
      end
    end

    private

    def query_successful?
      false
    end
  end
end
