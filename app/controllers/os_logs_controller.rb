class OsLogsController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]
  before_action :set_flie_o

  def create
    @os_log = @flie_o.os_logs.new(os_log_params)
    @os_log.save unless override?

    redirect_to @flie_o
  end

  private

  def set_flie_o
    resume_session
    @flie_o = FlieO.find(params.expect(:flie_o_id))
  end

  def os_log_params
    params.require(:os_log).permit(:in)
  end

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
    helps = ["-h", "--help", "help"]
    if helps.include?(args[Aro::Mancy::O]) || helps.include?(args[Aro::Mancy::S])
      if Current.user.nil?
        @os_log.out = I18n.t("flie_os.usage.guest")
      else
        @os_log.out = I18n.t("flie_os.usage.user")
      end
      return false
    end

    # this routes the user entering 'exit' to the 'out' os_cmd
    return true if short_circuit?(:exit, :out, args)
    # this allow for entering only 'passwd' to change password.
    return true if short_circuit?(:passwd, :passwd, args)

    # os_cmds
    os_cmds = OsCmd.where(name: args[Aro::Mancy::S]&.strip)
    if Current.user.nil?
      # pub commands
      os_cmd = os_cmds.find_by(access: :pub)
      if os_cmd.present?
        spawn_os_get(os_cmd)
        # do not save os_log
        return true
      else
        @os_log.out = I18n.t("flie_os.messages.invalid_command")
      end
    else
      os_cmd = os_cmds.first
      if os_cmd.present?
        spawn_os_get(os_cmd)
        return true
      else
        @os_log.out = I18n.t("flie_os.messages.invalid_command")
      end
    end

    return false
  end

  def compute(os_cmd)
    case os_cmd.name.to_sym
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

  def short_circuit?(cmd, route_cmd, args)
    if Current.user.present? &&
      cmd.to_s == args[Aro::Mancy::O].strip

      os_cmd = OsCmd.find_by(name: route_cmd)
      if os_cmd.present?
        spawn_os_get(os_cmd)
        return true
      end
    end

    return false
  end

  def spawn_os_get(os_cmd)
    # get the os_cmd's first os_get
    os_get = os_cmd.os_cmd_gets.find_by(step: Aro::Mancy::O).os_get

    # create an os_do
    os_do = @flie_o.os_dos.create(os_cmd: os_cmd, os_get: os_get)
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
      start_new_session_for(user)
      user.you.flie_o.generate_sign_in_os_log
    else
      response += I18n.t("flie_os.messages.invalid_account")
    end

    return response
  end

  def compute_out(os_cmd)
    response = ""

    c_do = latest_os_do_for(os_cmd, Aro::Mancy::O)
    if c_do.input == :y.to_s
      response += I18n.t("flie_os.messages.sign_out_success", name: @flie_o.you.user.email_address, timestamp: Time.now)
      response += Current.session.user_agent
      response += Current.session.ip_address
      terminate_session
    else
      response += I18n.t("flie_os.messages.doing_nothing")
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
        email_address: Current.user.email_address,
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
    @flie_o.you.user = User.new(
      email_address: e_do&.input,
      password: p_do&.input,
      password_confirmation: pc_do&.input
    )
    if @flie_o.you.user.save
      start_new_session_for(@flie_o.you.user)
      @flie_o.you.save
      # done this way because of routes
      @flie_o.generate_sign_in_os_log
    else
      response += @flie_o.you.user.errors.messages
    end

    return response
  end

  def latest_os_do_for(os_cmd, step)
    @flie_o.os_dos.order(created_at: :desc).find_by(
      os_get: os_cmd.os_cmd_gets.find_by(step: step).os_get
    )
  end

  def latest_email_os_do_for(os_cmd)
    latest_os_do_for(os_cmd, Aro::Mancy::O)
    email_os_get = os_cmd.os_cmd_gets.find_by(step: Aro::Mancy::O).os_get
    @flie_o.os_dos.order(created_at: :desc).find_by(
      os_get: email_os_get
    )
  end

  def latest_password_os_do_for(os_cmd)
    password_os_get = os_cmd.os_cmd_gets.find_by(step: Aro::Mancy::S).os_get
    @flie_o.os_dos.order(created_at: :desc).find_by(
      os_get: password_os_get
    )
  end

  def latest_password_confirm_os_do_for(os_cmd)
    password_confirm_os_get = os_cmd.os_cmd_gets.find_by(step: Aro::Mancy::OS).os_get
    @flie_o.os_dos.order(created_at: :desc).find_by(
      os_get: password_confirm_os_get
    )
  end

  def latest_confirm_os_do_for(os_cmd)
    text_os_get = os_cmd.os_cmd_gets.find_by(step: Aro::Mancy::O).os_get
    @flie_o.os_dos.order(created_at: :desc).find_by(
      os_get: text_os_get
    )
  end
end
