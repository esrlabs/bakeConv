# BakeConverter
# Author: Frauke Blossey
# 12.03.2015

require 'getoptlong'
require 'ConfigParser'
require 'Bake'
require 'Converter'

def main
  #-------------------------------------------------------
  # Get command line arguments:
  #-------------------------------------------------------
  converterConfigFile = workingdir = ''  
  # specify the options we accept and initialize them  
  opts = GetoptLong.new(  
  [ '--file', '-f', GetoptLong::OPTIONAL_ARGUMENT ],  
  [ '--workingdir', '-w', GetoptLong::OPTIONAL_ARGUMENT ]
  )  
   
  opts.each do |opt, arg|  
    case opt  
      when '--file'  
        converterConfigFile = arg  
      when '--workingdir'  
        workingdir = arg  
    end  
  end 
  
  filename = workingdir + converterConfigFile
  
  #-------------------------------------------------------
  # Starting converting process:
  #-------------------------------------------------------
  cp = BConv::ConfigParser.new(filename)
  puts "Reading config ..."
  mappings = cp.readConfig()
  puts "Converting " + mappings.length.to_s + " projects ..."
  
  idxCnt = 0
  
  mappings.each do |map|
    idxCnt += 1
    puts "Convert " + idxCnt.to_s + " from " + mappings.length.to_s + ": " + map['Proj2Convert'] + " (" + map['BuildConfig'] + ")"
    puts "Call Bake ..."
    bake = BConv::Bake.new
    bakefilename = bake.run(map)
    bhash = bake.getHash(workingdir+bakefilename)
    map.merge!(bhash)
    conv = BConv::Converter.new(workingdir)
    puts "Convert ..."
    conv.convert(map)
  end
  
  puts "Done"
end

main()















