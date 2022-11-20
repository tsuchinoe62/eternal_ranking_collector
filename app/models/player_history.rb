class PlayerHistory < ApplicationRecord
  validates :score, presence: true
  validates :level, presence: true
  validates :talent_id, presence: true
  validates :stored_on, presence: true

  belongs_to :player
end
