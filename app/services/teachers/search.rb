module Teachers
  class Search
    def initialize(query_string, filters: {})
      @query_string = query_string

      # TODO: no filters yet
      @_filters = filters
    end

    def search
      case
      when @query_string.blank?
        Teacher.all
      when trns.any?
        Teacher.where(trn: trns)
      else
        Teacher.search(@query_string)
      end
    end

    def trns
      @trns ||= @query_string.scan(%r(\d{7}))
    end
  end
end
