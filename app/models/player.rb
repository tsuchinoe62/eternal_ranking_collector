class Player < ApplicationRecord
  validates :name,      presence: true
  validates :server,    presence: true
  validates :job,       presence: true
  validates :score,     presence: true
  validates :level,     presence: true
  validates :talent_id, presence: true

  has_many :player_histories
end
