module Migration
  class Base < ApplicationRecord
    self.abstract_class = true

    connects_to database: { reading: :legacy_ecf, writing: :legacy_ecf }

    def readonly?
      true
    end
  end
end
