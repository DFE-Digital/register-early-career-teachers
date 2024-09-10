module Migration
  class Base < ApplicationRecord
    self.abstract_class = true

    connects_to database: { reading: :ecf1, writing: :ecf1 }

    def readonly?
      true
    end
  end
end
