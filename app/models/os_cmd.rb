class OsCmd < ApplicationRecord
  has_many :os_cmd_gets
  has_many :os_gets, through: :os_cmd_gets

  CAT = :cat.to_s
  HTML = :html.to_s
  NUKE = :nuke.to_s
  TED = :ted.to_s
  EXIT = :exit.to_s

  enum :access, [
    :guest_only,
    :user,
    :eamdc,
  ]
end
