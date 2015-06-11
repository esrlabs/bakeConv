module BConv
  
  require_relative 'Version'
  
  class Help
    
    def self.printHelp
      
      puts "bakeConv #{BConv::Version.number}\n\n"
      puts "Usage: bakeConv [options]"
      puts "-f, --file <configFile>            Config name for your conversion."
      puts "[-p, --project] <projName>         Project to convert (default are all projects mentioned in the config file).\n\n"
      puts "-v, --version                      Print version."
      puts "-h, --help                         Print this help."
      puts "--showdoc                          Open documentation."
      
    end
    
  end
  
end