require :fileutils.to_s
require :aro.to_s

module Flie
  module Os
    AROFLIE_PATH = :aroflie.to_s
    
    def self.start
      unless Dir.exist?(AROFLIE_PATH)
        system("aro dom new #{AROFLIE_PATH}")
        Dir.chdir(AROFLIE_PATH) do
          system("aro dom init")
          system("aos config set dimension ruby_facot") unless File.exist?("/dev/tarot")
        end
      end
    end
  end
end
