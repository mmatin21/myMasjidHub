class Prayer < ApplicationRecord
  belongs_to :masjid

  validates :name, presence: true
  validates :adhaan, presence: true
  validates :iqaamah, presence: true
end
