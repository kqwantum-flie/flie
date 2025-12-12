class OsLog < ApplicationRecord
  belongs_to :flie_o

  validate :input

  def input
    active_os_do = flie_o.os_dos.find_by(status: :active)
    if active_os_do.present?
      os_cmd = active_os_do.os_cmd
      # next os_do

      return false
    end

    args = self.in.split(" ")
    os_cmds = OsCmd.where(name: args[Aro::Mancy::S]&.strip)
    if flie_o.you.user.nil?
      # pub commands
      os_cmd = os_cmds.find_by(access: :pub)
      if os_cmd.present?
        # begin os_cmd os_gets process

        # get the os_cmd's first os_get
        os_get = os_cmd.os_gets.first

        # create an os_do
        os_do = flie_o.os_dos.create(os_cmd: os_cmd, os_get: os_get)

        # do not save os_log
        return false
      else
        self.out = I18n.t("flie_os.usage.no_user")
      end
    else
      # todo:
      # non-pub cmds
    end

    true
  end
end
