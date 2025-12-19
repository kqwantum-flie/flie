class ApplicationMailer < ActionMailer::Base
  default from: "droond374@gmail.com" #Rails.application.credentials.dig(mailer: :user_name)
  layout :mailer.to_s
end
