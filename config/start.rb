require :fileutils.to_s
require :aro.to_s

module Flie
  module Os
    AROFLIE_PATH = :aroflie.to_s

    def self.start
      unless Dir.exist?(Flie::Os::AROFLIE_PATH)
        system(:"aro dom new".to_s + " #{Flie::Os::AROFLIE_PATH}")
        Dir.chdir(Flie::Os::AROFLIE_PATH) do
          root_youser = Rails.application.credentials.dig(:aos, :root_youser)
          root_password = Rails.application.credentials.dig(:aos, :root_password)
          system(:"aro dom init".to_s + " #{root_youser} #{root_password}")
          Flie::Os.system_pxy(:"config dimension ruby_facot") unless File.exist?(Aro::T::DEV_TAROT_FILE.to_s)
        end
      end
    end

    def self.system_pxy(cmd, user = nil)
      you_arg = ""
      unless user.nil?
        you_arg = "#{Aos::Os::YOU_FLAG} #{user.aroflie_you}"
      end

      return `#{:aos} #{cmd} #{you_arg}`
    end
  end
end

