class Company < ApplicationRecord
	has_many :users, dependent: :destroy
	has_many :vehicles, dependent: :destroy

	validates :name, presence: true
end
