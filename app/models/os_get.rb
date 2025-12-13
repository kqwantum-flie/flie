class OsGet < ApplicationRecord
  has_many :os_cmd_gets
  has_many :os_cmds, through: :os_cmd_gets

  # used for html input type attribute
  # except for the nothing...
  enum :input_type, [
    :email,
    :nothing,
    :password,
    :text,
  ]
end
