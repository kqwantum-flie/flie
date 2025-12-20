class OsCmd < ApplicationRecord
  has_many :os_cmd_gets
  has_many :os_gets, through: :os_cmd_gets

  NUKE = :nuke.to_s
  EXIT = :exit.to_s

  enum :access, [
    :guest_only,
    :user,
    :eamdc,
  ]
end
