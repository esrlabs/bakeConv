# BakeConverter
# Author: Frauke Blossey
# 12.03.2015

require 'getoptlong'
require './lib/ConfigParser'
require './lib/Bake'
require './lib/Converter'

def main
  #-------------------------------------------------------
  # Get command line arguments:
  #-------------------------------------------------------
  converterConfigFile = ''
  setMock = false  
    
  opts = GetoptLong.new(  
  [ '--file', '-f', GetoptLong::OPTIONAL_ARGUMENT ],  
  [ '--mock', GetoptLong::OPTIONAL_ARGUMENT ]
  )  
   
  opts.each do |opt, arg|  
    case opt  
      when '--file'  
        converterConfigFile = arg  
      when '--mock'  
        setMock = true  
    end  
  end 
  
  if converterConfigFile == ""
    abort 'Error: config file is missing!'
  end
  
  configFile = converterConfigFile.gsub('\\','/')      
  
  #-------------------------------------------------------
  # Starting converting process:
  #-------------------------------------------------------
  cp = BConv::ConfigParser.new(configFile)
  puts "Reading config ..."
  mappings = cp.readConfig
  puts "Converting " + mappings.length.to_s + " projects ..."
  
  idxCnt = 0
  
  mappings.each do |map|
    idxCnt += 1
    puts "Convert " + idxCnt.to_s + " from " + mappings.length.to_s + ": " + map['Proj2Convert'] + " (" + map['BuildConfig'] + ")"
    puts "Call Bake ..."
    bake = BConv::Bake.new(map, setMock)
    bakeLines = bake.run
    bhash = bake.getHash(bakeLines)
    map.merge!(bhash)
    conv = BConv::Converter.new(map, configFile)
    puts "Convert ..."
    conv.convert
  end
  
  puts "Done"
end

#-------------------------------------------------------
# Call the bakeConverter:
#-------------------------------------------------------
main















