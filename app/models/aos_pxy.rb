class AosPxy < ApplicationRecord
  has_many :os_dos
  has_many :pxy_excepts

  ALLOW_DEFAULTS = {
    AOS: [
      # see other comment below: # todo: add aos lib usage as pxy_excepts
      Aos::Os::CMDS[:AMG][:key],
      Aos::Os::CMDS[:CD][:key],
      Aos::Os::CMDS[:COR][:key],
      Aos::Os::CMDS[:DATA][:key],
      Aos::Os::CMDS[:HELP][:key],
      Aos::Os::CMDS[:LL][:key],
      Aos::Os::CMDS[:LS][:key],
      Aos::Os::CMDS[:PWD][:key],
    ],
    CLI: [
      CLI::CMDS[:ARO][:COR],
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

  def self.user_home
    AosPxy.find_or_create_by(name: :user_home)
  end

  def set_width(flie_o)
    # todo: this is not working
    return if flie_o.you.user.nil? || flie_o.width == Aro::Mancy::O
    run_it!(:"cor width #{flie_o.width}", flie_o.you.user)
  end

  def init_user(user)
    out = run_it!(:"cor", user)
    run_it!(:"cor interface lanimret", user)
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

      cmd_excepts = pxy_excepts.where(cmd: args)
      unless is_allowed
        is_allowed = cmd_excepts.any?
      end

      unless is_allowed
        user_home_response = compute_user_home(user, os_do.input)
        return user_home_response unless user_home_response.nil?

        available_cmds = cmd_excepts.pluck(:cmd) +
          AosPxy::ALLOW_DEFAULTS[:AOS].map(&:to_s) +
          AosPxy::ALLOW_DEFAULTS[:CLI].map{|c| "#{:aro.to_s} #{c}"} +
          Aro::Dom::D.reserved_words

        return I18n.t("aroflie.messages.command_not_available", cmd: cmd, available_cmds: available_cmds.sort.join("\n"))
      end
    end

    run_it!(cmd, user)
  end

  def compute_user_home(user, args)
    return nil unless user.you.within_home?
    Dir.chdir(Rails.root.join(Flie::Os::AROFLIE_PATH, user.you.pwd)) do
      begin
        return `#{args}` # raw passthrough
      rescue => e
        return e.backtrace.join("\n")
      end
    end
  end

  private

  def run_it!(cmd, user)
    response = nil
    Dir.chdir(Flie::Os::AROFLIE_PATH) do
      response = Flie::Os.system_pxy(cmd, user)
    end
    user.you.sync! unless user.you.nil?
    return response
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
