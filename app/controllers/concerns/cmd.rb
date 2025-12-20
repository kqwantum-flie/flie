module Cmd
  extend ActiveSupport::Concern

  # return true means that Flie::Os is running an os_cmd
  #   example: getting sign up info.
  #   todo: ctrl+c in the browser breaks out of the
  #         current os_cmd if present
  # return false means that flie is awaiting input from the
  # web terminal
  def override?

    # active os_do
    active_os_do = @flie_o.os_dos.find_by(status: :active)
    if active_os_do.present?
      # get the running os_cmd
      os_cmd = active_os_do.os_cmd

      # set the active os_do's input value from the user input
      # todo: do not store plaintext passwords - base64?
      active_os_do.update(input: @os_log.in)

      # complete the active_os_do
      active_os_do.complete!

      # get the current os_cmd_get
      current = os_cmd.os_cmd_gets.find_by(os_get: active_os_do.os_get)

      # get the next os_get
      next_os_get = os_cmd.os_cmd_gets.find_by(
        step: current.step + Aro::Mancy::S
      )&.os_get

      if next_os_get.present?
        # if next os_get is present, generate an os_do
        @flie_o.os_dos.create(os_cmd: os_cmd, os_get: next_os_get)
        return true
      else
        # os_cmd complete
        # clear os_log in
        @os_log.in = nil
        # set os_log out to cmd_response
        @os_log.out = compute(os_cmd)
        return false
      end
    end

    # get args
    args = @os_log.in&.split(" ") || []
    return false if args.empty? || args[Aro::Mancy::O].nil?

    # version
    if ["-v", "--version"].include?(args[Aro::Mancy::S])
      @os_log.out = "v" + Flie::Application::VERSION
      return false
    end

    # helps
    helps = ["-h", "--help"]
    if helps.include?(args[Aro::Mancy::O]) || helps.include?(args[Aro::Mancy::S])
      if @current_user.nil?
        @os_log.out = I18n.t("flie_os.usage.guest")
      else
        @os_log.out = I18n.t("flie_os.usage.user")
      end
      return false
    end

    return true if short_circuit?(# 'exit' => 'flie out' os_cmd.
      OsCmd::EXIT,
      Flie::Os::CMDS[:OUT][:name],
      args
    ) || short_circuit?(# 'nuke' => 'flie clear' os_cmd.
      OsCmd::NUKE,
      Flie::Os::CMDS[:CLEAR][:name],
      args,
      require_user: false
    ) || short_circuit?(          # 'passwd' => 'flie passwd' os_cmd.
      Flie::Os::CMDS[:PASSWD][:name],
      Flie::Os::CMDS[:PASSWD][:name],
      args
    )

    # os_cmds
    os_cmds = OsCmd.where(name: args[Aro::Mancy::S]&.strip)
    if @current_user.present?
      if os_cmd = os_cmds.find_by(access: :user)
        # user flie commands
        spawn_os_do(os_cmd)
        return true # do not save @os_log
      elsif @current_user.is_eamdc?
        if os_cmd = os_cmds.find_by(access: :eamdc)
          # eamdc flie commands
          spawn_os_do(os_cmd)
          return true # do not save @os_log
        end
      end

      # passthrough to aos
      af_os_cmd = OsCmd.find_by(name: :aroflie)
      # get the os_cmd's first os_get
      af_os_get = af_os_cmd.os_cmd_gets.find_by(step: Aro::Mancy::O).os_get
      # create an os_do
      af_os_do = @flie_o.os_dos.create(os_cmd: af_os_cmd, os_get: af_os_get)
      # set os_do's input to passthrough args
      af_os_do.input = args.join(" ")
      # save and complete the os_do
      af_os_do.save
      af_os_do.complete!
      # compute expects all of the os_cmd's
      # os_dos to be status -> complete
      @os_log.out = compute(af_os_cmd)
    elsif os_cmd = os_cmds.find_by(access: :guest_only)
      # guest_only flie commands
      spawn_os_do(os_cmd)
      return true # do not save @os_log
    else
      @os_log.out = I18n.t("flie_os.messages.invalid_command")
    end

    # returning false causes @os_log to be saved
    return false
  end

  def short_circuit?(cmd, route_cmd, args, require_user: true)
    if (require_user ? @current_user.present? : true) &&
      cmd.to_s == args[Aro::Mancy::O].strip
      if os_cmd = OsCmd.find_by(name: route_cmd)
        spawn_os_do(os_cmd)
        return true
      end
    end

    return false
  end

  def compute(os_cmd)
    case os_cmd.name.to_sym
    when Flie::Os::CMDS[:AROFLIE][:name]
      compute_aroflie(os_cmd)
    when Flie::Os::CMDS[:CLEAR][:name]
      compute_clear(os_cmd)
    when Flie::Os::CMDS[:IN][:name]
      compute_in(os_cmd)
    when Flie::Os::CMDS[:OUT][:name]
      compute_out(os_cmd)
    when Flie::Os::CMDS[:PASSWD][:name]
      compute_passwd(os_cmd)
    when Flie::Os::CMDS[:UP][:name]
      compute_up(os_cmd)
    end
  end

  def spawn_os_do(os_cmd)
    # get the os_cmd's first os_get
    os_get = os_cmd.os_cmd_gets.find_by(step: Aro::Mancy::O).os_get

    # create an os_do
    os_do = @flie_o.os_dos.create(os_cmd: os_cmd, os_get: os_get)
  end

  def compute_aroflie(os_cmd)
    response = ""
    c_do = latest_os_do_for(os_cmd, Aro::Mancy::O)
    if c_do.present?
      return OsDo::BUSY if c_do.doing
      c_do.update(doing: true)
      response = c_do.aos_pxy.compute(@flie_o.you.user, c_do)
      c_do.update(doing: false)
    else
      # something went wrong
      response = I18n.t("flie_os.messages.invalid_command")
    end
    response
  end

  def compute_clear(os_cmd)
    response = ""

    c_do = latest_os_do_for(os_cmd, Aro::Mancy::O)
    if c_do.input == Flie::Os::Y.to_s
      @flie_o.clear_terminal!
    else
      response += I18n.t("flie_os.messages.doing_nothing")
    end

    return response
  end

  def compute_in(os_cmd)
    response = ""

    e_do = latest_os_do_for(os_cmd, Aro::Mancy::O)
    p_do = latest_os_do_for(os_cmd, Aro::Mancy::S)
    user = User.authenticate_by(
      email_address: e_do&.input,
      password: p_do&.input
    )
    if user.present?
      unless user.unverified?
        start_new_session_for(user)
        user.you.flie_o.generate_sign_in_os_log
      else
        # todo: create a way to resend verification email
        # eg: flie verify <email_address>
        response += I18n.t("flie_os.messages.verify_email", email_address: user.email_address)
      end
    else
      response += I18n.t("flie_os.messages.invalid_account")
    end

    return response
  end

  def compute_out(os_cmd)
    response = ""

    c_do = latest_os_do_for(os_cmd, Aro::Mancy::O)
    if c_do.input == Flie::Os::Y.to_s
      response = I18n.t("flie_os.messages.sign_out_success", name: @flie_o.you.user.email_address, timestamp: Time.now)
      response += "\n"
      response += Current.session.user_agent
      response += "\n"
      response += Current.session.ip_address
      terminate_session
    else
      response = I18n.t("flie_os.messages.doing_nothing")
    end

    return response
  end

  def compute_passwd(os_cmd)
    response = ""

    current_do = latest_os_do_for(os_cmd, Aro::Mancy::O)
    new_do = latest_os_do_for(os_cmd, Aro::Mancy::S)
    confirm_do = latest_os_do_for(os_cmd, Aro::Mancy::OS)
    if new_do&.input == current_do&.input
      response += I18n.t("flie_os.messages.password_error")
      response += "\n"
      response += I18n.t("flie_os.messages.password_no_previous")
    elsif new_do&.input != confirm_do&.input
      response += I18n.t("flie_os.messages.password_error")
      response += "\n"
      response += I18n.t("flie_os.messages.passwords_not_equal")
    else
      user = User.authenticate_by(
        email_address: @current_user.email_address,
        password: current_do&.input
      )
      if user.present?
        user.update(
          password: new_do&.input,
          password_confirmation: confirm_do&.input
        )
        if user.errors.any?
          response += "#{user.errors.messages}"
        else
          response += I18n.t("flie_os.messages.password_changed")
        end
      else
        response += I18n.t("flie_os.messages.password_error")
        response += "\n"
        response += I18n.t("flie_os.messages.doing_nothing")
      end
    end

    return response
  end

  def compute_up(os_cmd)
    response = ""

    e_do = latest_os_do_for(os_cmd, Aro::Mancy::O)
    p_do = latest_os_do_for(os_cmd, Aro::Mancy::S)
    pc_do = latest_os_do_for(os_cmd, Aro::Mancy::OS)
    existing_user = User.find_by(email_address: e_do&.input)
    unless existing_user.present?
      user = User.new(
        email_address: e_do&.input,
        password: p_do&.input,
        password_confirmation: pc_do&.input
      )
      if user.save
        user.send_verification_email!
        response += I18n.t("flie_os.messages.verify_email", email_address: user.email_address)
      else
        response += "#{user.errors.messages}"
      end
    else
      response = I18n.t("flie_os.messages.user_exists", name: e_do.input)
      response += "\n"
      if existing_user.unverified?
        # resend verification email
        existing_user.send_verification_email!
        response += I18n.t("flie_os.messages.verify_email", email_address: existing_user.email_address)
      else
        response += I18n.t("flie_os.messages.doing_nothing")
      end
    end

    return response
  end

  def latest_os_do_for(os_cmd, step)
    @flie_o.os_dos.order(created_at: :desc).find_by(
      os_get: os_cmd.os_cmd_gets.find_by(step: step).os_get
    )
  end
end
