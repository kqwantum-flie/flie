class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :pxy_excepts
  has_one :you

  after_create :interface_with_flie

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def aroflie_you
    email_address.split("@")[Aro::Mancy::O].gsub(/[^\w]/, "_")
  end


  private

  # this assigns a flie_o and
  # you to the user if needed.
  def interface_with_flie
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
