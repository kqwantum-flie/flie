class FlieO < ApplicationRecord
  has_one :you
  has_many :os_logs
  has_many :os_dos
  has_many :tbufs

  after_create :create_you
  before_validation :set_width

  PS1 = Flie::Os.name

  def ps1ify(inner = nil)
    unless inner.present?
      if you.user.present?
        inner = "#{you.user.is_eamdc? ? Rails.application.credentials.dig(:aos, :root_youser) : you.user.email_address}"
      else
        inner = Flie::Os.name
      end
    end

    ">[#{inner}]>:$"
  end

  def broadcast
    ps1 = nil
    os_do = os_dos.find_by(status: :active)
    input_type = :text
    if os_do.present?
      input_type = os_do.os_get.input_type.to_s
      ps1 = ps1ify(os_do.os_get.prompt)
    else
      # default
      ps1 = self.ps1ify
    end
    payload = {
      ps1: ps1,
      input_type: input_type
    }
    ActionCable.server.broadcast("flie_o_#{id}", payload)
  end

  def broadcast_page_refresh
    ActionCable.server.broadcast("flie_o_#{id}", {
      refresh: true
    })
  end

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
    # todo: this is not working
    self.width = FlieO.first.width if FlieO.count > Aro::Mancy::O
  end

  def create_you
    self.you = You.create
  end
end
