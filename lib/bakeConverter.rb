# BakeConverter
# Author: Frauke Blossey
# 12.03.2015

require 'rubygems'
require 'launchy'
require_relative 'ConfigParser'
require_relative 'Bake'
require_relative 'Converter'
require_relative 'Version'
require_relative 'Help'
require_relative 'PathAdapt'
require_relative 'Filter'

def main
  #-------------------------------------------------------
  # Get command line arguments:
  #-------------------------------------------------------
  converterConfigFile = ""
  projToConvert = ""
  cfgFleFromCmdLne = ""
  setMock = false
  debugMode = false
  mapConverted = 0
 
  begin
  if ARGV[0] == "--debug"
    ARGV.rotate!
  end
    
  args = ARGV.select.each_with_index{|str, i| i.even? && str[0] == "-"}
  opts = ARGV.select.each_with_index { |str, i| i.odd? && str[0] != "-" }
  
  puts Hash[(args.zip opts)]
  
  if ARGV[0] != "--help" && ARGV[0] != "-h" && ARGV[0] != "--show_doc" && ARGV[0] != "--version" && ARGV[0] != "-v" && ARGV[0] != "--show_license" && ARGV[0] != "--mock"
    if (!ARGV.include?("-f") &&  !ARGV.include?("--file")) && ARGV.length != 0
      puts "Error: \'-f\' is missing! (try --help)"
      exit(-1)
    end
  end

  if ARGV.length == 1 && ARGV[0] != "--help" && ARGV[0] != "-h" && ARGV[0] != "--show_doc" && ARGV[0] != "--version" && ARGV[0] != "-v" && ARGV[0] != "--show_license" && ARGV[0] != "--mock"
    #puts "Error: Too less arguments! (try --help)"
    puts "Config file is missing!" if opts[0] == nil
    exit(-1)
  elsif ARGV.length == 0 || (ARGV.length == 1 && ARGV[0] == "--mock")
    puts "Error: Too less arguments! (try --help)"
    exit(-1)
  end

  Hash[(args.zip opts)].each do |k,v|
    case k
    when "-f"
      cfgFleFromCmdLne = v
      converterConfigFile = File.expand_path(v)
      abort "Error: Config file is missing!" if converterConfigFile == nil
    when "--file"
      converterConfigFile = v
      abort "Error: Config file is missing!" if converterConfigFile == nil
    when "-p"
      projToConvert = v
      abort "Error: project is missing!" if projToConvert == nil
    when "--project"
      projToConvert = v
      abort "Error: project is missing!" if projToConvert == nil
    when "--mock"
      setMock = true
    when "--version"
      puts "bakeConv #{BConv::Version.number}"
      exit(0)
    when "-v"
      puts "bakeConv #{BConv::Version.number}"
      exit(0)
    when "--help"
      BConv::Help.printHelp
      exit(0)
    when "-h"
      BConv::Help.printHelp
      exit(0)
    when "--debug"
      debugMode = true
    when "--show_doc"
      Launchy.open("http://esrlabs.github.io/bakeConv/")
      exit(0)
    when "--show_license"
      puts
      File.open(File.expand_path("../license.txt", File.dirname(__FILE__))) do |l|
        while(line = l.gets) != nil
          puts line
        end
      end
      exit(0)
    else
      puts "Error: don't know '#{k}'! (try --help)"
      exit(-1)
    end
  end
   
  rescue Exception => e
  puts e.backtrace if debugMode == true
  exit(-1)
  end

  configFile = converterConfigFile.gsub('\\','/')  
  cfgFleFromCmdLne = cfgFleFromCmdLne.gsub('\\','/') 
 
  puts "cfgFle: #{cfgFleFromCmdLne}"
 
  #-------------------------------------------------------
  # Starting converting process:
  #-------------------------------------------------------
  cp = BConv::ConfigParser.new(configFile, projToConvert, debugMode)
  
  puts "Reading config..."
  status, mappings = cp.readConfig
  
  abort "Error: Config file is empty OR the requested project(s) is commented out!" if mappings.length == 0
  puts "Converting #{mappings.length} projects..."
  idxCnt = 0
  
  mappings.each do |map|
    idxCnt += 1
    puts "Convert #{idxCnt} from #{mappings.length}: #{map['Proj2Convert']} (#{map['BuildConfig']})"
    puts "Call Bake..."
    bake = BConv::Bake.new(map, setMock, configFile, debugMode)
    bakeLines = bake.run
    puts bakeLines if debugMode == true
    abort "Error while trying to call bake!" unless $?.success?
    bhash = bake.getHash(bakeLines)
    if bhash != nil
      map.each do |k,v|
        if (k == "EXCLUDE_BAKE_SOURCES") || (k == "EXCLUDE_BAKE_INCLUDES") || (k == "EXCLUDE_BAKE_DEPENDENCIES")          
          bhash = BConv::Filter.hashFilter(k, v, bhash)
        end
      end
      bhash_adapted = BConv::PathAdapt.adapt_path(map['OutputFile'], bhash, cfgFleFromCmdLne, debugMode)
    end
    
    if bhash_adapted != nil
      bhash_adapted.each {|k,v| map[k] = v unless (map.has_key?k)}
      conv = BConv::Converter.new(map, configFile, debugMode)
      puts "Convert..."
      status = conv.convert
      mapConverted = mapConverted + 1 if status == 0
    end
  end
  
  puts "Done: Converted #{mapConverted} from #{mappings.length} projects."
  
  if (mapConverted == mappings.length) && (mapConverted != 0)
    return exit(0)
  else
    return exit(1)
  end
  
end

#-------------------------------------------------------
# Call the bakeConverter:
#-------------------------------------------------------
main















