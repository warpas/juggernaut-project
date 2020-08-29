require_relative "../../date_time_helper"
require_relative "../activities/context"

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
      category_list.map do |category|
        time_in_minutes = get_time_for(
          category: category,
          report_detailed: @detailed_report,
          report_summarized: @cumulative_report
        )
        DateTimeHelper.sheets_duration_format(time_in_minutes)
      end
    end

    def category_list
      Activities.list_categories
    end

    def get_time_for(category:, report_detailed:, report_summarized:)
      # TODO: define outside rules for these categories
      if category == "consumption"
        time_for_consumption(report: report_detailed)
      elsif category == "creative"
        time_for_creative(report: report_detailed)
      elsif category == "intentional"
        # TODO: to be implemented
      elsif category == "unintentional"
        # TODO: #1 to be implemented
      elsif category == "work"
        time_for_work(report: report_detailed)
      elsif category == "games"
        time_for_games(report: report_detailed)
      elsif category == "exercise"
        time_for_exercise(report: report_detailed)
      elsif category == "reading"
        time_for_reading(report: report_summarized)
      elsif category == "writing"
        time_for_writing(report: report_summarized)
      elsif category == "sleep"
        time_for_sleep(report: report_summarized)
      end
    end

    def time_for_consumption(report:)
      category_entry_list = report["data"].select { |time_entry|
        time_entry["tags"].include?("game") ||
          time_entry["project"] == "Abnegation - Passive entertainment" ||
          time_entry["project"] == "Growth - Reading" ||
          time_entry["project"] == "Growth - Study" ||
          time_entry["project"] == "Growth - Edutainment" ||
          time_entry["project"] == "Growth - intentional Video"
      }
      if category_entry_list.empty?
        0
      else
        total_category_time = category_entry_list.map { |entry| entry["dur"] }.sum
        total_category_time
      end
    end

    def time_for_creative(report:)
      category_entry_list = report["data"].select { |time_entry|
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
        0
      else
        total_category_time = category_entry_list.map { |entry| entry["dur"] }.sum
        total_category_time
      end
    end

    def time_for_work(report:)
      category_entry_list = report["data"].select { |time_entry|
        time_entry["tags"].include?("work")
      }
      if category_entry_list.empty?
        0
      else
        total_category_time = category_entry_list.map { |entry| entry["dur"] }.sum
        total_category_time
      end
    end

    def time_for_games(report:)
      category_entry_list = report["data"].select { |time_entry|
        time_entry["tags"].include?("game")
      }
      if category_entry_list.empty?
        0
      else
        total_category_time = category_entry_list.map { |entry| entry["dur"] }.sum
        total_category_time
      end
    end

    def time_for_exercise(report:)
      category_entry_list = report["data"].select { |time_entry|
        time_entry["tags"].include?("exercise")
      }
      if category_entry_list.empty?
        0
      else
        total_category_time = category_entry_list.map { |entry| entry["dur"] }.sum
        total_category_time
      end
    end

    def time_for_reading(report:)
      category_entry_list = report["data"].select { |time_entry|
        time_entry["title"]["project"] == "Growth - Reading"
      }
      if category_entry_list.empty?
        0
      else
        category_entry_list.first["time"]
      end
    end

    def time_for_writing(report:)
      category_entry_list = report["data"].select { |time_entry|
        time_entry["title"]["project"] == "Creative - Writing"
      }
      if category_entry_list.empty?
        0
      else
        category_entry_list.first["time"]
      end
    end

    def time_for_sleep(report:)
      category_entry_list = report["data"].select { |time_entry|
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
