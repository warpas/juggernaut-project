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

  def self.sheets_duration_format(milliseconds)
    time_integer = milliseconds.to_i
    time_in_seconds = time_integer / 1000
    total_minutes = time_in_seconds / 60
    "#{total_minutes}"
  end

  def self.get_next_closest_sunday(date)
    date - date.cwday + 7
  end

  def self.get_week_start(date)
    date - date.cwday + 1
  end

  def self.get_next_midnight(date)
    next_day = date + 1
    DateTime.new(next_day.year, next_day.month, next_day.day, 0, 0, 1, '+02:00')
  end

  def self.seconds_before(date_time, seconds)
    date_time - 0.00001 * seconds
  end

  def self.seconds_after(date_time, seconds)
    date_time + 0.00001 * seconds
  end
end
