class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :pxy_excepts
  has_one :you

  after_commit :interface_with_flie

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  enum :status, [
    :unverified,
    :verified
  ]

  def aroflie_you
    email_address.split("@")[Aro::Mancy::O].gsub(/[^\w]/, "_")
  end

  def send_verification_email!
    t = rand(9999..999999).to_s +
      Aro::T.read_dev_tarot(false) +
      rand(9999..999999).to_s +
      Aro::T.read_dev_tarot(false)

    update(verification_token: t)
    FlieMailer.verification(self.reload).deliver_now!
  end


  private

  # this assigns a flie_o and
  # you to the user if needed.
  def interface_with_flie
    return unless verified?
    return unless you.nil?

    # grab any existing userless you
    self.you = You.find_by(user: nil)

    if self.you.nil?
      # flie_o after_create creates a you
      flie_o = FlieO.create

      # assign that new you to self.you
      self.you = flie_o.you
    end

    # ensure you have a flie_o interface via self.you
    self.you.save
    save
  end
end
