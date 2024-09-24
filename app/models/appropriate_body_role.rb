class AppropriateBodyRole < ApplicationRecord
  belongs_to :user
  belongs_to :appropriate_body
end
