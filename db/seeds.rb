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
  os_cmd = OsCmd.find_or_create_by(name: cmd[:name], access: cmd[:access])
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

# ez user for development
if Rails.env.development?
  eamdc = :"e@m.c"
  pass = :pass
  eamdc_user = User.new(
    email_address: eamdc.to_s,
    password: pass.to_s,
    password_confirmation: pass.to_s,
  )
  eamdc_user.save unless User.find_by(email_address: eamdc).present?
end
