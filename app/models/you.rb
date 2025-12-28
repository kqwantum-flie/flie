class You < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :flie_o

  def sync!
    return unless user.present?
    query = self.user.email_address
    if self.user.is_eamdc?
      query = Rails.application.credentials.dig(:aos, :root_youser)
    end
    aos_you = JSON.parse(Flie::Os.fpx_read_you(query))
    new_pwd = nil
    new_home = nil
    Dir.chdir(Flie::Os::AROFLIE_PATH) do
      new_pwd = Aos::Os.osify(aos_you[:pwd.to_s])
      new_home = Aos::Os.osify(aos_you[:home.to_s])
    end

    return unless aos_you.present? && aos_you[:name.to_s] == query

    new_bytes = aos_you[:stream_bytes.to_s]&.to_i || 0
    write_bytes = new_bytes - self.stream_bytes
    # update you
    update(
      pwd: new_pwd,
      home: new_home,
      stream_bytes: new_bytes.to_i
    )
    self.reload
    # update screen
    return unless File.exist?(stream_file)

    file = File.open(stream_file, 'r')
    file.seek(-write_bytes, IO::SEEK_END)
    ActionCable.server.broadcast("flie_o_#{flie_o.id}", {body: file.read(write_bytes)})
    file.close
  end

  def home?
    self.pwd == self.home
  end

  def within_home?
    self.pwd.include?(self.home)
  end

  def homify(filepath)
    File.join(
      self.pwd.gsub(self.home, ""),
      filepath
    )[Aro::Mancy::S..]
  end

  def stream_file
    File.join(Flie::Os::AROFLIE_PATH, home, ".aro_srt")
  end
end
