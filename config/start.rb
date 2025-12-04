require :fileutils.to_s
# require :aro.to_s

# ensures the aroflie arows directory exists and is configured properly
module Aroflie
  class Start
    AROFLIE_PATH = :arows.to_s
    
    def self.start
      relative_path = "#{File.basename(Dir.getwd)}/#{File.basename(__FILE__)}"
      puts "beginning #{Aroflie.name} startup process in #{relative_path}..."
      puts "running #{File.basename(__FILE__)} -> #{self.name}.#{__method__}..."
      unless Dir.exist?(AROFLIE_PATH)
        puts "attempting to create the #{AROFLIE_PATH} directory..."
        FileUtils.mkdir(AROFLIE_PATH, verbose: true)
      end

      # todo: any additional configurations
      # ...

      puts "#{Aroflie.name} startup complete!"
    end
  end
end
