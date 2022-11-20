class Talent < ApplicationRecord
  validates :name,      presence: true, uniqueness: true
  validates :talent_id, presence: true, uniqueness: true
end
