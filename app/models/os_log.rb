class OsLog < ApplicationRecord
  belongs_to :flie_o
  has_rich_text :out

  before_save :broadcast

  private

  def broadcast
    flie_o.broadcast

    ActionCable.server.broadcast("flie_o_#{flie_o.id}", {body: "#{flie_o.ps1ify} #{self.in}"}) if self.in.present?
    unless out.body.nil?
      out.body.to_plain_text.split("\n").each{|line|
        ActionCable.server.broadcast("flie_o_#{flie_o.id}", {body: line})
      }
    end
  end
end
