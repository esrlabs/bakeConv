# bake to Converter
# Author: Frauke Blossey
# Start @ 12.03.2015

# includes
require 'getoptlong'
  
# get command line arguments:
#unless ARGV.length == 2
#  puts 'Usage: ruby bakeToConverter.rb -f bakeToConverter/Converter.config -w C:\_dev\projects'  
#  exit  
#end
  
converter_config_file = workingdir = ''  
# specify the options we accept and initialize them  
opts = GetoptLong.new(  
[ '--file', '-f', GetoptLong::OPTIONAL_ARGUMENT ],  
[ '--workingdir', '-w', GetoptLong::OPTIONAL_ARGUMENT ]
)  
 
opts.each do |opt, arg|  
  case opt  
    when '--file'  
      converter_config_file = arg  
    when '--workingdir'  
      workingdir = arg  
  end  
end 

# read Converter.config file to get all necessary parameters
#File.open(workingdir+converter_config_file) do |f|
#  File.readlines(f).each do |line| 
#  end
#end

fileName = workingdir + converter_config_file

def wordExistsInFile(fileName, seekingExpression)
  File.open(fileName) do |f|
    File.readlines(f).each do |line|
      line.match(seekingExpression) do
        ar = line.split(" = ")
        return false if ar.length != 2
        return ar
      end
    end
  end
end

mainProj = wordExistsInFile(fileName, "MainProj")
buildConfig = wordExistsInFile(fileName, "BuildConfig")
proj2Convert = wordExistsInFile(fileName, "Proj2Convert")

bakeMap = {}
bakeMap[mainProj[0].strip] = mainProj[1].strip
bakeMap[buildConfig[0].strip] = buildConfig[1].strip
bakeMap[proj2Convert[0].strip] = proj2Convert[1].strip

# call bake to get the necessary bakeOutput file
def bake( bakeMap )
	cmd = "bake -m " + bakeMap['MainProj'] + " -b " + bakeMap['BuildConfig'] + " -p " + bakeMap['Proj2Convert'] + " --printConverter"
#	status = system( cmd )
#	if status == false
#		abort 'Error while trying to call bake!'
#	end
    puts cmd
    return "Files/\BakeOutput.txt"
end


bakeFileName = bake(bakeMap)


