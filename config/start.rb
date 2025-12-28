require :aro.to_s

module Flie
  module Os
    AROFLIE_PATH = :aroflie.to_s

    # todo: make this work once aos fpx args are complete
    def self.fpx_read_you(you_name)
      url = URI.parse(File.join(
        "http://localhost:7474", :"you/#{you_name}".to_s))
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      res.body
    end

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

      require :"rack/cors".to_s
      require :sinatra.to_s
      # todo: this should work
      # Aos::Fpx::Server.stop
      # Aos::Fpx::Server.start
      Dir.chdir(Flie::Os::AROFLIE_PATH) do
        # todo: make this
        # system("aos fpx -h localhost -p 7474 -t 60 -l aroflie/root/flie/fpx.log --flie localhost:3000")
        system("aos fpx restart &")
      end

      return nil
    end

    def self.system_pxy(cmd, user = nil)
      you_arg = ""
      unless user.nil?
        you_arg = "#{Aos::Os::YOU_FLAG} #{user.is_eamdc? ? Rails.application.credentials.dig(:aos, :root_youser) : user.email_address}"
      end

      `#{:aos} #{cmd} #{you_arg}`
    end

    def self.generate_eamdc
      em = Rails.application.credentials.dig(:eamdc, :email_address)
      pw = Rails.application.credentials.dig(:eamdc, :password)

      return if User.find_by(email_address: em).present?
      # baton
      eamdc_user = User.new(
        email_address: em,
        password: pw,
        password_confirmation: pw,
        status: Aro::Mancy::S,
      )
      eamdc_user.save
    end
  end
end

