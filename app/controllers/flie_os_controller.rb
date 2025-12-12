class FlieOsController < ApplicationController
  allow_unauthenticated_access only: %i[ new show ]
  before_action :set_you

  def new
    redirect_to @flie_o
  end

  def show

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
