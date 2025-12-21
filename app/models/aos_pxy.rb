class AosPxy < ApplicationRecord
  has_many :os_dos
  has_many :pxy_excepts

  ALLOW_DEFAULTS = {
    AOS: [
      # see other comment below: # todo: add aos lib usage as pxy_excepts
      Aos::Os::CMDS[:AMG][:key],
      Aos::Os::CMDS[:CD][:key],
      Aos::Os::CMDS[:CONFIG][:key],
      Aos::Os::CMDS[:DATA][:key],
      Aos::Os::CMDS[:HELP][:key],
      Aos::Os::CMDS[:LS][:key],
      Aos::Os::CMDS[:PWD][:key],
    ],
    CLI: [
      CLI::CMDS[:ARO][:CONFIG],
      CLI::CMDS[:ARO][:TECK],
      CLI::CMDS[:TECK][:DRAW],
      CLI::CMDS[:TECK][:NEW],
      CLI::CMDS[:TECK][:REPLACE],
      CLI::CMDS[:TECK][:SHOW],
      CLI::CMDS[:TECK][:SHUFFLE],
    ]
  }

  def self.default
    AosPxy.find_or_create_by(name: :default)
  end

  def set_width(flie_o)
    return if flie_o.you.user.nil? || flie_o.width == Aro::Mancy::O
    run_it!(:"config width #{flie_o.width}", flie_o.you.user)
  end

  def init_user(user)
    out = run_it!(:"config", user)
    run_it!(:"config interface lanimret", user)
    unless user.you.flie_o.nil?
      set_width(user.you.flie_o)
    end

    out
  end

  def compute(user, os_do = nil)
    cmd = :noop.to_s
    if os_do.present? && os_dos.include?(os_do)
      cmd = os_do.input || cmd # use noop if os_do.input is nil

      args = cmd.split(" ")
      args = maybe_strip_you(args)

      # initialize
      is_allowed = false
      error_message = ""

      # whitelisted cli cmd
      if args[Aro::Mancy::O] != :aro.to_s
        is_allowed = AosPxy::ALLOW_DEFAULTS[:AOS].include?(args[Aro::Mancy::O].to_sym)
      elsif args.count > Aro::Mancy::S
        is_allowed = AosPxy::ALLOW_DEFAULTS[:CLI].include?(args[Aro::Mancy::S].to_sym)
      elsif args.count == Aro::Mancy::S &&
        args[Aro::Mancy::O] == :aro.to_s
        is_allowed = true
      end

      unless is_allowed
        is_allowed = Aro::Dom::D.reserved_words.include?(args[Aro::Mancy::O]) &&
          args.count == Aro::Mancy::S
      end

      # pxy_excepts here
      # todo: add aos lib usage as pxy_excepts
      # Dir.chdir(Flie::Os::AROFLIE_PATH) do

      #   fpxies = Aos::Flie.pxies(user.email_address)
      #   if aos_you.present?
      #     fpxies = aos_you.fpxies.where(cmd: args.join(" "))
      #     fpxies = aos_you.fpxies.where(cmd: args[0]) unless fpxies.any?
      #     fpxies = aos_you.fpxies.where(cmd: [args[0], args[1]].join(" ")) unless fpxies.any?
      #     is_allowed = fpxies.any?
      #   end
      # end
      cmd_excepts = pxy_excepts.where(cmd: args)
      unless is_allowed
        is_allowed = cmd_excepts.any?
      end

      unless is_allowed
        available_cmds = cmd_excepts.pluck(:cmd) +
          AosPxy::ALLOW_DEFAULTS[:AOS].map(&:to_s) +
          AosPxy::ALLOW_DEFAULTS[:CLI].map{|c| "#{:aro.to_s} #{c}"} +
          Aro::Dom::D.reserved_words

        return I18n.t("aroflie.messages.command_not_available", cmd: cmd, available_cmds: available_cmds.sort.join("\n"))
      end
    end

    run_it!(cmd, user)
  end

  private

  def run_it!(cmd, user)
    Dir.chdir(Flie::Os::AROFLIE_PATH) do
      Flie::Os.system_pxy(cmd, user)
    end
  end

  def maybe_strip_you(args)
    if args.include?(Aos::Os::YOU) &&
      pxy_excepts.where(user: user, cmd: Aos::Os::YOU).empty?
      # strip off Aos::Os::YOU
      i = args.index(Aos::Os::YOU)
      Aro::Mancy::OS.times do
        args.delete_at(i)
      end
    end

    args
  end

end
