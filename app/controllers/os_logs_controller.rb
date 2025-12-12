class OsLogsController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]
  before_action :set_flie_o

  def create
    @os_log = @flie_o.os_logs.create(os_log_params)

    redirect_to @flie_o
  end

  private

  def set_flie_o
    @flie_o = FlieO.find(params.expect(:flie_o_id))
  end

  def os_log_params
    params.require(:os_log).permit(:in)
  end
end
