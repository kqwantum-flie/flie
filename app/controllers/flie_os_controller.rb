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
    # get an unassigned you
    # this allows for interaction without a user (aka logged out)
    @you = You.find_by(user: nil)
    if @you.nil?
      @flie_o = FlieO.create
      @you = @flie_o.you
    else
      @flie_o = @you.flie_o
    end
  end
end
