class Search
  SEARCH_OBJECTS = %w(All Question Answer Comment User).freeze

  def self.search(query, filter)
    if filter == 'All'
      ThinkingSphinx.search ThinkingSphinx::Query.escape(query)
    elsif SEARCH_OBJECTS.include?(filter)
      filter.constantize.search ThinkingSphinx::Query.escape(query)
    else
      []
    end
  end
end
