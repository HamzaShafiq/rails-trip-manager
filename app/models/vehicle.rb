class Vehicle < ApplicationRecord
	belongs_to :company
	has_many :trips, dependent: :destroy

	validates :name, presence: true
end
