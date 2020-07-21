module Summaries
  class Daily
    def self.build_trends_for(date: Date.today)
      [[date.to_s, "0", "0", "0", "0", "0", "0", "0", "0"]]
    end
  end
end
