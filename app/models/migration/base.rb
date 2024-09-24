module Migration
  class Base < ApplicationRecord
    self.abstract_class = true

    connects_to database: { reading: :legacy, writing: :legacy } unless Rails.env.test?

    def readonly?
      !Rails.env.test? # allow factories in test
    end
  end
end
