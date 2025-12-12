class OsGet < ApplicationRecord
  has_many :os_cmd_gets
  has_many :os_cmds, through: :os_cmd_gets

  enum :input_type, [
    :password,
    :email,
    :text,
  ]
end
