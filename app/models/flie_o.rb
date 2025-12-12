class FlieO < ApplicationRecord
  has_one :you
  has_many :os_logs
  has_many :os_dos

  after_create :create_you

  def generate_sign_in_os_log
    out = I18n.t("flie_os.messages.sign_in_success", name: you.user.email_address, timestamp: Time.now)
    out += "\n"
    out += Current.session.user_agent
    out += "\n"
    out += Current.session.ip_address
    os_logs.create(out: out)
  end

  private

  def create_you
    self.you = You.create
  end
end
