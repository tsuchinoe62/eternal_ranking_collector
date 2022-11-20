class GuildHistory < ApplicationRecord
  validates :master, presence: true
  validates :score, presence: true
  validates :member, presence: true

  belongs_to :guild
end
