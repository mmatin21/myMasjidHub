class Pledge < ApplicationRecord
  belongs_to :fundraiser
  belongs_to :contact
  has_many :donations
end
