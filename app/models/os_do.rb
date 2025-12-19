class OsDo < ApplicationRecord
  belongs_to :flie_o
  belongs_to :os_cmd
  belongs_to :os_get
  belongs_to :aos_pxy

  BUSY = :busy.to_s

  enum :status, [
    :active,
    :complete,
  ]

  before_validation :set_aos_pxy

  private

  def set_aos_pxy
    self.aos_pxy = AosPxy.default if self.aos_pxy.nil?
  end
end
