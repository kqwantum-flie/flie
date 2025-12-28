class PxyExcept < ApplicationRecord
  belongs_to :aos_pxy
  belongs_to :user

  def sync!
    # todo: sync with aos fpxies
    # todo: add aos lib usage as pxy_excepts
    # need to use fpx
    # Dir.chdir(Flie::Os::AROFLIE_PATH) do

    #   fpxies = Aos::Flie.pxies(user.email_address)
    #   if aos_you.present?
    #     fpxies = aos_you.fpxies.where(cmd: args.join(" "))
    #     fpxies = aos_you.fpxies.where(cmd: args[0]) unless fpxies.any?
    #     fpxies = aos_you.fpxies.where(cmd: [args[0], args[1]].join(" ")) unless fpxies.any?
    #     is_allowed = fpxies.any?
    #   end
    # end
  end
end
