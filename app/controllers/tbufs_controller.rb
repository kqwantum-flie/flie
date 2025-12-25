class TbufsController < ApplicationController
  before_action :set_tbuf

  def update
    @tbuf.update(content: params.expect(:content))
    @tbuf.closed!
    redirect_to @flie_o
  end

  private

  def set_tbuf
    @flie_o = FlieO.find(params.expect(:flie_o_id))
    @tbuf = @flie_o.tbufs.find_by(id: params.expect(:id))
  end

end

