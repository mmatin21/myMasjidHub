class Balance < ApplicationRecord
  belongs_to :masjid
  belongs_to :expense
  belongs_to :revenue
  belongs_to :fundraiser
end
