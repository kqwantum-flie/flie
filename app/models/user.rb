class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :pxy_excepts
  has_one :you


  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def aroflie_you
    email_address.split("@")[Aro::Mancy::O].gsub(/[^\w]/, "_")
  end
end
