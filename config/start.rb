require :fileutils.to_s
require :aro.to_s

module Flie
  module Os
    ARODOME_PATH = :arodome.to_s
    
    def self.start
      unless Dir.exist?(ARODOME_PATH)
        system("aro dom new arodome")
        Dir.chdir(ARODOME_PATH) do
          system("aro dom init")
          system("aos config set format json")
          system("aos config set dimension ruby_facot") unless File.exist?("/dev/tarot")
        end
      end
    end
  end
end
