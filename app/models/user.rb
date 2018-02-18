class User < ApplicationRecord
  belongs_to :company
  has_many :trips, dependent: :destroy

  before_create :set_api_key

  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_key: token)
    end
  end

  def admin?
    self.role == 'admin'
  end

  def read_only?
    self.role == 'read-only'
  end

  private

    def set_api_key
      self.api_key = self.generate_api_key
    end
end
