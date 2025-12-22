require :"fpx".to_s
class You < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :flie_o

  def sync!
    return unless user.present?
    query = self.user.email_address
    if self.user.is_eamdc?
      query = Rails.application.credentials.dig(:aos, :root_youser)
    end
    aos_you = JSON.parse(Aos::Fpx.read_you(query))
    puts aos_you
    puts aos_you.nil? || aos_you[:name.to_s] != self.user.email_address
    new_pwd = nil
    new_home = nil
    Dir.chdir(Flie::Os::AROFLIE_PATH) do
      new_pwd = Aos::Os.osify(aos_you[:pwd.to_s])
      new_home = Aos::Os.osify(aos_you[:home.to_s])
    end
    update(
      pwd: new_pwd,
      home: new_home
    ) unless aos_you.nil? || aos_you[:name.to_s] != query
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
end
