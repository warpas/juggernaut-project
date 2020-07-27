require_relative "../../../date_time_helper"

module Summaries
  module Daily
    class Trends
      def initialize(cumulative: {"data" => []}, detailed: {"data" => []})
        @cumulative_report = cumulative
        @detailed_report = detailed
      end

      def build(date: Date.today)
        do_everything_once(date: date)
      end

      private

      def do_everything_once(date: (Date.today - 1).to_s)
        reading_time = get_time_for(date: date, category: "reading", report_detailed: @detailed_report, report_summarized: @cumulative_report)
        writing_time = get_time_for(date: date, category: "writing", report_detailed: @detailed_report, report_summarized: @cumulative_report)
        work_time = get_time_for(date: date, category: "work", report_detailed: @detailed_report, report_summarized: @cumulative_report)
        games_time = get_time_for(date: date, category: "games", report_detailed: @detailed_report, report_summarized: @cumulative_report)
        consumption_time = get_time_for(date: date, category: "consumption", report_detailed: @detailed_report, report_summarized: @cumulative_report)
        creative_time = get_time_for(date: date, category: "creative", report_detailed: @detailed_report, report_summarized: @cumulative_report)
        sleep_time = get_time_for(date: date, category: "sleep", report_detailed: @detailed_report, report_summarized: @cumulative_report)
        exercise_time = get_time_for(date: date, category: "exercise", report_detailed: @detailed_report, report_summarized: @cumulative_report)

        values = [
          [
            date.to_s,
            DateTimeHelper.sheets_duration_format(reading_time),
            DateTimeHelper.sheets_duration_format(writing_time),
            DateTimeHelper.sheets_duration_format(work_time),
            DateTimeHelper.sheets_duration_format(games_time),
            DateTimeHelper.sheets_duration_format(consumption_time),
            DateTimeHelper.sheets_duration_format(creative_time),
            DateTimeHelper.sheets_duration_format(sleep_time),
            DateTimeHelper.sheets_duration_format(exercise_time)
          ]
        ]
      end

      def get_time_for(date:, category:, report_detailed:, report_summarized:)
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
end
