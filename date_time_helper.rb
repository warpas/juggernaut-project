module DateTimeHelper
  def self.readable_duration(milliseconds)
    time_integer = milliseconds.to_i
    time_in_seconds = time_integer / 1000
    hours = time_in_seconds / 3600
    minutes_in_seconds = time_in_seconds % 3600
    minutes = minutes_in_seconds / 60
    seconds = minutes_in_seconds % 60
    "#{hours} hours, #{minutes} minutes and #{seconds} seconds"
  end
end
