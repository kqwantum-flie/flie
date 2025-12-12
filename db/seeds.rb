module Flie::Os
  CMDS = {
    IN: {
      name: :in,
      access: OsCmd.accesses[:pub],
      gets: [
        :email,
        :password
      ]
    },
    UP: {
      name: :up,
      access: OsCmd.accesses[:pub],
      gets: [
        :email,
        :password,
        :password_confirm
      ]
    },
  }

  GETS = {
    PASSWORD: {
      name: :password,
      input_type: :password
    },
    PASSWORD_CONFIRMATION: {
      name: :password_confirm,
      input_type: :password
    },
    EMAIL: {
      name: :email,
      input_type: :email
    },
    TEXT: {
      name: :text,
      input_type: :text
    },
  }
end

# create gets
Flie::Os::GETS.each do |k, get|
  OsGet.create(
    name: get[:name],
    prompt: I18n.t("os_gets.prompts.#{get[:name]}"),
    input_type: get[:input_type]
  )
end

# create commands
Flie::Os::CMDS.each do |k, cmd|
  os_cmd = OsCmd.create(name: cmd[:name], access: cmd[:access])
  cmd[:gets].each_with_index{|get, i|
    OsCmdGet.create(
      os_cmd: os_cmd,
      os_get: OsGet.find_by(name: get),
      step: i
    )
  }
end
