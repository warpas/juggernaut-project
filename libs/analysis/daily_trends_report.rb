require_relative "../../date_time_helper"

module Analysis
  class TrendsPayload
    attr_reader :payload

    def initialize(trends: [], date: Date.today)
      @payload = prepare(trends, date)
    end

    private

    def prepare(list, date)
      [list.unshift(date.to_s)]
    end
  end

  class TrendCategories
    CATEGORIES = %w[reading writing work games consumption creative sleep exercise].freeze

    def self.as_list
      CATEGORIES
    end
  end

  class DailyTrendsReport
    def initialize(cumulative: {"data" => []}, detailed: {"data" => []})
      @cumulative_report = cumulative
      @detailed_report = detailed
    end

    def build(date: Date.today)
      TrendsPayload.new(trends: trends_list, date: date).payload
    end

    private

    def trends_list
      TrendCategories.as_list.map do |category|
        time_in_minutes = get_time_for(
          category: category,
          report_detailed: @detailed_report,
          report_summarized: @cumulative_report
        )
        DateTimeHelper.sheets_duration_format(time_in_minutes)
      end
    end

    def get_time_for(category:, report_detailed:, report_summarized:)
      # TODO: define outside rules for these categories
      # TODO: Add tests before switching to these rules
      if category == "consumption"
        category_entry_list = report_detailed["data"].select { |time_entry|
          time_entry["tags"].include?("game") ||
            time_entry["project"] == "Abnegation - Passive entertainment" ||
            time_entry["project"] == "Growth - Reading" ||
            time_entry["project"] == "Growth - Study" ||
            time_entry["project"] == "Growth - Edutainment" ||
            time_entry["project"] == "Growth - intentional Video"
        }
        if category_entry_list.empty?
          return 0
        else
          total_category_time = category_entry_list.map { |entry| entry["dur"] }.sum
          return total_category_time
        end
      end
      if category == "creative"
        category_entry_list = report_detailed["data"].select { |time_entry|
          time_entry["description"] == "Focused work" ||
            time_entry["project"] == "Creative - Writing" ||
            time_entry["project"] == "Dev - Scripts and utilities" ||
            time_entry["project"] == "Dev - Finance app" ||
            time_entry["project"] == "Dev - Resume generator" ||
            time_entry["project"] == "Dev - Prototyping" ||
            time_entry["project"] == "Dev - Juggernaut" ||
            time_entry["project"] == "Dev - Other Projects"
        }
        if category_entry_list.empty?
          return 0
        else
          total_category_time = category_entry_list.map { |entry| entry["dur"] }.sum
          return total_category_time
        end
      end
      if category == "intentional"
        # TODO: to be implemented
      end
      if category == "unintentional"
        # TODO: to be implemented
      end
      if category == "work"
        category_entry_list = report_detailed["data"].select { |time_entry|
          time_entry["tags"].include?("work")
        }
        if category_entry_list.empty?
          return 0
        else
          total_category_time = category_entry_list.map { |entry| entry["dur"] }.sum
          return total_category_time
        end
      end
      if category == "games"
        category_entry_list = report_detailed["data"].select { |time_entry|
          time_entry["tags"].include?("game")
        }
        if category_entry_list.empty?
          return 0
        else
          total_category_time = category_entry_list.map { |entry| entry["dur"] }.sum
          return total_category_time
        end
      end
      if category == "exercise"
        category_entry_list = report_detailed["data"].select { |time_entry|
          time_entry["tags"].include?("exercise")
        }
        if category_entry_list.empty?
          return 0
        else
          total_category_time = category_entry_list.map { |entry| entry["dur"] }.sum
          return total_category_time
        end
      end
      if category == "reading"
        category_entry_list = report_summarized["data"].select { |time_entry|
          time_entry["title"]["project"] == "Growth - Reading"
        }
        if category_entry_list.empty?
          return 0
        else
          return category_entry_list.first["time"]
        end
      end
      if category == "writing"
        category_entry_list = report_summarized["data"].select { |time_entry|
          time_entry["title"]["project"] == "Creative - Writing"
        }
        if category_entry_list.empty?
          return 0
        else
          return category_entry_list.first["time"]
        end
      end
      if category == "sleep"
        category_entry_list = report_summarized["data"].select { |time_entry|
          time_entry["title"]["project"] == "Sleeping"
        }
        if category_entry_list.empty?
          0
        else
          category_entry_list.first["time"]
        end
      end
    end
  end
end
