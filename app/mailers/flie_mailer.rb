class FlieMailer < ApplicationMailer
  def verification(user)
    @user = user
    mail(
      to: @user.email_address,
      subject: "#{Flie::Os.name} verification",
    )
  end
end
