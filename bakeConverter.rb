# BakeConverter
# Author: Frauke Blossey
# 12.03.2015

require 'getoptlong'
require_relative 'lib/ConfigParser'
require_relative 'lib/Bake'
require_relative 'lib/Converter'

def main
  #-------------------------------------------------------
  # Get command line arguments:
  #-------------------------------------------------------
  converterConfigFile = ""
  projToConvert = ""
  setMock = false  
 
  opts = GetoptLong.new(  
    [ '--file', '-f', GetoptLong::REQUIRED_ARGUMENT ],  
    [ '--mock', GetoptLong::OPTIONAL_ARGUMENT ],
    [ '--project', '-p', GetoptLong::OPTIONAL_ARGUMENT]
    ) 
  
  abort "Wrong spelling or command -f / --file is missing!" if ARGV[0] != ('-f' || '--file')
  abort "Error: config file is missing!" if ARGV[0] == ('-f' || '--file') && (ARGV[1] == "--mock")
  
  if ARGV.length > 5
    abort "Too many arguments!"
  end
  
  if (ARGV[4] != '--mock') && (ARGV.length == 5) 
    abort "Wrong spelling. It has to be called --mock!"
  elsif (ARGV[2] != '--mock') && (ARGV.length == 3)
    abort "Wrong spelling. It has to be called --mock!"
  elsif (ARGV[2] != '-p' || ARGV[2] != '--project') && (ARGV.length >= 4)
    abort "Wrong spelling. It has to be called --project or -p!"
  end

  opts.each do |opt, arg|  
    case opt  
      when '--file'
        converterConfigFile = arg  
      when '--mock'  
        setMock = true
      when '--project'
        projToConvert = arg
    end
  end

  abort "Error: config file is missing!" if converterConfigFile == ''
  
  configFile = converterConfigFile.gsub('\\','/')      
 
  #-------------------------------------------------------
  # Starting converting process:
  #-------------------------------------------------------
  cp = BConv::ConfigParser.new(configFile, projToConvert)
  
  puts "Reading config..."
  mappings = cp.readConfig
  #puts mappings
  
  abort "Error: Config file is empty!" if mappings.length == 0
  puts "Converting #{mappings.length} projects..."
  
  idxCnt = 0
  
  mappings.each do |map|
    idxCnt += 1
    puts "Convert #{idxCnt} from #{mappings.length}: #{map['Proj2Convert']} (#{map['BuildConfig']})"
    puts "Call Bake..."
    bake = BConv::Bake.new(map, setMock, configFile)
    bakeLines = bake.run
    bhash = bake.getHash(bakeLines)
    #puts bhash
    if bhash != nil
      map.merge!(bhash)
      #puts map
      conv = BConv::Converter.new(map, configFile)
      puts "Convert..."
      conv.convert
    end
  end
  
  puts "Done"
end

#-------------------------------------------------------
# Call the bakeConverter:
#-------------------------------------------------------
main















