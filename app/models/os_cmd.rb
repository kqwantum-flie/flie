class OsCmd < ApplicationRecord
  has_many :os_cmd_gets
  has_many :os_gets, through: :os_cmd_gets

  EXIT = :exit.to_s

  enum :access, [
    :pub,
    :pro,
    :pri,
  ]
end
