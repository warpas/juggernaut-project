module Activities
  class Category
    CATEGORIES = %w[reading writing work games consumption creative sleep exercise].freeze

    def self.list
      CATEGORIES
    end
  end
end
