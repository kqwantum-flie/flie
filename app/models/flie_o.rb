class FlieO < ApplicationRecord
  has_one :you
  has_many :os_logs
  has_many :os_dos
  has_many :tbufs

  after_create :create_you
  before_validation :set_width

  def generate_sign_in_os_log
    out = I18n.t("flie_os.messages.sign_in_success", name: you.user.email_address, timestamp: Time.now)
    out += "\n"
    out += Current.session.user_agent
    out += "\n"
    out += Current.session.ip_address
    out += AosPxy.default.init_user(you.user)
    out += "\n"
    os_logs.create(out: out)
  end

  def clear_terminal!
    os_logs.destroy_all
    os_dos.destroy_all
    save
  end

  private

  def set_width
    self.width = FlieO.first.width if FlieO.count > Aro::Mancy::O
  end

  def create_you
    self.you = You.create
  end
end
