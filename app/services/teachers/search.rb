module Teachers
  class Search
    attr_reader :scope

    def initialize(query_string: :ignore, appropriate_body: :ignore, appropriate_body_ids: :ignore)
      @scope = Teacher.distinct
      @query_string = query_string

      where_appropriate_body_is(appropriate_body)
      where_appropriate_body_ids_in(appropriate_body_ids)
      where_query_matches(query_string)
    end

    def search
      scope.order(:last_name, :first_name, :id)
    end

  private

    def ignore?(filter:)
      filter == :ignore
    end

    def where_appropriate_body_is(appropriate_body)
      return if ignore?(filter: appropriate_body)

      # If no appropriate body provided in regular context, return nothing
      @scope = if appropriate_body.nil?
                 Teacher.none
               else
                 AppropriateBodies::CurrentTeachers.new(appropriate_body).current
               end
    end

    def where_appropriate_body_ids_in(appropriate_body_ids)
      return if ignore?(filter: appropriate_body_ids)

      # In admin context, if no IDs provided, show all current teachers
      @scope = if @scope == Teacher.none
                 Teacher.none
               else
                 Admin::CurrentTeachers.new(appropriate_body_ids).current
               end
    end

    def where_query_matches(query_string)
      return if ignore?(filter: query_string)
      return if query_string.blank?
      return if @scope == Teacher.none

      trns = query_string.scan(%r(\d{7}))
      @scope = if trns.any?
                 @scope.where(trn: trns)
               else
                 @scope.search(query_string)
               end
    end
  end
end
