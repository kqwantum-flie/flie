def load_get(k)
  return unless Flie::Os::GETS.keys.include?(k.to_sym)
  get = Flie::Os::GETS[k.to_sym]
  OsGet.find_or_create_by(
    name: get[:name],
    prompt: I18n.t("os_gets.prompts.#{get[:name]}"),
    input_type: get[:input_type]
  )
end

def load_cmd(k)
  return unless Flie::Os::CMDS.keys.include?(k.to_sym)
  cmd = Flie::Os::CMDS[k.to_sym]
  os_cmd = OsCmd.find_or_create_by(
    name: cmd[:name],
    description: I18n.t("os_cmds.descriptions.#{cmd[:name]}"),
    access: cmd[:access]
  )
  cmd[:gets].each_with_index{|get, i|
    OsCmdGet.find_or_create_by(
      os_cmd: os_cmd,
      os_get: OsGet.find_by(name: get),
      step: i
    )
  }
end

# create gets
Flie::Os::GETS.keys.each{|k| load_get(k) }

# create commands
Flie::Os::CMDS.keys.each{|k| load_cmd(k) }

Flie::Os.generate_eamdc

if Rails.env.development?
  em = "test@user.dev"
  pw = "pass"

  return if User.find_by(email_address: em).present?
  # baton
  test_user = User.new(
    email_address: em,
    password: pw,
    password_confirmation: pw,
    status: Aro::Mancy::S,
  )
  test_user.save
end
