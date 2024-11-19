module Schools
  class Search
    def initialize(q)
      @q = q
    end

    def call
      query.order("gias_schools.name")
    end

  private

    def all_schools
      School.includes(:gias_school).references(:gias_schools).all
    end

    def query
      @q.blank? ? all_schools : School.search(@q)
    end
  end
end
