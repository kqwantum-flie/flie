class FlieO < ApplicationRecord
  has_one :you
  has_many :os_logs

  after_create :create_you

  def create_you
    update(you: You.new(pwd: "/"))
  end
end
