module Teachers
  class Search
    def initialize(query_string, appropriate_body: nil, filters: {})
      @scope = if appropriate_body.present?
                 AppropriateBodies::CurrentTeachers.new(appropriate_body).current
               else
                 Teacher
               end

      @query_string = query_string

      # TODO: no filters yet
      @_filters = filters
    end

    def search
      case
      when @query_string.blank?
        @scope.all
      when trns.any?
        @scope.where(trn: trns)
      else
        @scope.search(@query_string)
      end
    end

    def trns
      @trns ||= @query_string.scan(%r(\d{7}))
    end
  end
end
