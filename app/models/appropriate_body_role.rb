class AppropriateBodyRole < ApplicationRecord
  belongs_to :user
  belongs_to :appropriate_body

  validates :user_id, presence: { message: "Choose a user" }
  validates :appropriate_body_id, presence: { message: "Choose an appropriate body" }
end
