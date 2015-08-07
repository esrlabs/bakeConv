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
  setMock = false  
 
  begin
  args = ARGV.select.each_with_index{|str, i| i.even? && str[0] == "-"}
  opts = ARGV.select.each_with_index{|str, i| i.odd? && str[0] != "-"}
  
   #puts Hash[(args.zip opts)]
  
  if ARGV[0] != "--help" && ARGV[0] != "-h" && ARGV[0] != "--show_doc" && ARGV[0] != "--version" && ARGV[0] != "-v" && ARGV[0] != "--show_license" && ARGV[0] != "--mock"
    if (!ARGV.include?("-f") &&  !ARGV.include?("--file")) && ARGV.length != 0
      puts "Error: \'-f\' is missing! (try --help)"
      exit(-1)
    end
  end

  if ARGV.length == 1 && ARGV[0] != "--help" && ARGV[0] != "-h" && ARGV[0] != "--show_doc" && ARGV[0] != "--version" && ARGV[0] != "-v" && ARGV[0] != "--show_license" && ARGV[0] != "--mock"
    puts "Error: Too less arguments! (try --help)"
    puts "Config file is missing!" if opts[0] == nil
    exit(-1)
  elsif ARGV.length == 0 || (ARGV.length == 1 && ARGV[0] == "--mock")
    puts "Error: Too less arguments! (try --help)"
    exit(-1)
  end

  Hash[(args.zip opts)].each do |k,v|
    case k
    when "-f"
      converterConfigFile = v
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
      puts "bakeConverter #{BConv::Version.number}"
      exit(0)
    when "-v"
      puts "bakeConverter #{BConv::Version.number}"
      exit(0)
    when "--help"
      BConv::Help.printHelp
      exit(0)
    when "-h"
      BConv::Help.printHelp
      exit(0)
    when "--show_doc"
      Launchy.open(File.expand_path("../doc/doc.html", File.dirname(__FILE__)))
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
   
  rescue => e
  puts "Error in arguments!"
  #puts e.to_s    #for debug mode
  exit(-1)
  end

  configFile = converterConfigFile.gsub('\\','/')   
 
  #-------------------------------------------------------
  # Starting converting process:
  #-------------------------------------------------------
  cp = BConv::ConfigParser.new(configFile, projToConvert)
  
  puts "Reading config..."
  mappings = cp.readConfig
  
  abort "Error: Config file is empty OR the requested project(s) is commented out!" if mappings.length == 0
  puts "Converting #{mappings.length} projects..."
  
  idxCnt = 0
  
  mappings.each do |map|
    idxCnt += 1
    puts "Convert #{idxCnt} from #{mappings.length}: #{map['Proj2Convert']} (#{map['BuildConfig']})"
    puts "Call Bake..."
    bake = BConv::Bake.new(map, setMock, configFile)
    bakeLines = bake.run
    #puts bakeLines
    bhash = bake.getHash(bakeLines)
    if bhash != nil
      map.each do |k,v|
        if (k == "GMOCK_FILTER" && v == "true") || k == "DEPENDENCIES_FILTER" 
          bhash = BConv::Filter.hashFilter(k, v, bhash)
        end
      end
    end
    bhash_adapted = BConv::PathAdapt.adapt_path(map['OutputFileName'], bhash)
    
    if bhash_adapted != nil
      bhash_adapted.each {|k,v| map[k] = v unless (map.has_key?k && k!="DEPENDENCIES_FILTER")}
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















