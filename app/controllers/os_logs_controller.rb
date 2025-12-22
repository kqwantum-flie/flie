class OsLogsController < ApplicationController
  include Cmd
  allow_unauthenticated_access only: %i[ create ]
  before_action :set_flie_o

  def create
    @final_redirect = Proc.new{redirect_to @flie_o.reload}
    @os_log = @flie_o.os_logs.new(os_log_params)
    @os_log.save unless override?

    if @screen_width.present?
      @flie_o.update(width: @screen_width.to_i)
    end

    @final_redirect.call
  end

  private

  def set_flie_o
    params.permit!
    resume_session
    @current_user = Current.user
    @flie_o = FlieO.find(params.expect(:flie_o_id))
    @screen_width = params.permit(:screen_width)[:screen_width]
  end

  def os_log_params
    params.permit!
    params.require(:os_log).permit(:in)
  end
end

