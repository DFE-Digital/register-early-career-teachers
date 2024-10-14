module AppropriateBodies
  class Search
    def initialize(query_string)
      @query_string = query_string
    end

    def search
      query = if @query_string.blank?
                AppropriateBody.all
              else
                AppropriateBody.where("name ILIKE ?", "%#{@query_string}%")
              end

      query.order(name: 'asc')
    end
  end
end
