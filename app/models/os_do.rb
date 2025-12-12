class OsDo < ApplicationRecord
  belongs_to :flie_o
  belongs_to :os_cmd
  belongs_to :os_get

  enum :status, [
    :active,
    :complete,
  ]
end
