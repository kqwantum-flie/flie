class FlieO < ApplicationRecord
  has_one :you
  has_many :os_logs
  has_many :os_dos

  after_create :create_you

  def create_you
    self.you = You.create
  end
end
