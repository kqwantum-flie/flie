class FlieOsController < ApplicationController
  allow_unauthenticated_access only: %i[new show verify]
  before_action :set_you

  def new
    redirect_to @flie_o
  end

  def show
  end

  def verify
    user = User.find_by(verification_token: params[:id])
    if params[:id].present? && user.present?
      if user.verified?
        @flie_o.os_logs.create(out: "email already verified.")
      else
        # set user to verified status
        user.verified!
        user.update(verification_token: nil)

        # generate verified success os_log
        @flie_o.os_logs.create(out: "email verified successfully.")

        # assign user to @flie_o.you
        @flie_o.you.user = user
        @flie_o.you.save

        # start a new session
        start_new_session_for(@flie_o.you.user)

        # generate sign in os_log
        @flie_o.generate_sign_in_os_log

        # initialize aos user
        AosPxy.default.init_user(@flie_o.you.user)
      end
    else
      @flie_o.os_logs.create(out: "could not verify email.")
    end

    redirect_to @flie_o
  end

  def html
    html_path = params[:filepath]
    # hidden files do not work
    # todo: validation
    file_ext = request.original_url.split(".").last
    if file_ext != :html.to_s
      @flie_o.os_logs.last.update(out: "invalid format #{file_ext}. must be html")
      redirect_to @flie_o
    else
      html_path += "." + file_ext unless file_ext.nil?
      real_path = Rails.root.join(
        Flie::Os::AROFLIE_PATH,
        @flie_o.you.home,
        html_path
      )

      render inline: HTMLEntities.new.decode(File.read(real_path.to_s))
    end
  end

  def ted
    ted_path = params[:filepath]
    # hidden files do not work
    # todo: validation
    file_ext = request.original_url.split(".").last
    ted_path += "." + file_ext unless file_ext.nil?
    real_path = Rails.root.join(
      Flie::Os::AROFLIE_PATH,
      @flie_o.you.home,
      ted_path
    )
    @tbuf = @flie_o.tbufs.find_or_create_by(real_path: real_path.to_s, ted_path: ted_path)
    @tbuf.opened!
    respond_to {|format| format.any{render :ted, formats: :html}}
  end

  private

  def set_you
    @flie_o = FlieO.find_by(id: params[:id])
    # get an unassigned you
    # this allows for interaction without a user (aka logged out)
    resume_session
    user = Current.user
    if user.present? && @flie_o&.you&.user != user
      redirect_to user.you.flie_o
    elsif user.nil? && @flie_o&.you&.user.present?
      redirect_to :root
    elsif @flie_o.nil?
      you = You.find_by(user: user || nil)
      if you.nil?
        @flie_o = FlieO.create
        you = @flie_o.you
      end
      @flie_o = you.flie_o
    end

    @current_user = user
  end
end
