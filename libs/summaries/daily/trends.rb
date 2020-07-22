module Summaries
  module Daily
    class Trends
      def initialize(cumulative:, detailed:)
        @cumulative_report = cumulative
        @detailed_report = detailed
      end

      def build(date: Date.today)
        [[date.to_s, "0", "0", "0", "0", "0", "0", "0", "0"]]
      end
    end
  end
end
