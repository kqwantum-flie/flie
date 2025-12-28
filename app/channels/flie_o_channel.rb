class FlieOChannel < ApplicationCable::Channel
  after_subscribe :broadcast_ps1
  def subscribed
    stream_from "flie_o_#{params[:flie_o_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def broadcast_ps1
    self.connection.flie_o.broadcast
  end
end
