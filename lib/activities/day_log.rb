module Activities
  class DayLog
    attr_reader :date

    def initialize(date:)
      @date = date
    end
  end
end
