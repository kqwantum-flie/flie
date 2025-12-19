class ApplicationMailer < ActionMailer::Base
  default from: :"#{Flie::Os::AROFLIE_PATH}@flie.proton.me".to_s
  layout :mailer.to_s
end
