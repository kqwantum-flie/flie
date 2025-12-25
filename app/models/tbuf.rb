class Tbuf < ApplicationRecord
  belongs_to :flie_o
  has_rich_text :content

  after_update :process
  before_create :fill

  enum :status, [
    :opened,
    :closed,
    :gone
  ]

  def get_extension
    real_path.split(".").last
  end

  private

  def process
    if closed?
      output = content.body.to_plain_text
      if get_extension == :html.to_s
        output = content.body.to_html
      end
      File.open(self.real_path, "w"){|f| f.write(output)}
      flie_o.os_logs.last.update(out: "#{ted_path} updated successfully.")
    end

    destroy if closed? || gone?
  end

  def fill
    self.content = File.read(self.real_path)
  end
end
