class Guild < ApplicationRecord
  validates :name, presence: true
  validates :server, presence: true
  validates :master, presence: true
  validates :score, presence: true
  validates :point, presence: true
  validates :member_count, presence: true
  validates :guild_id, presence: true, uniqueness: true
end
