# bake to Converter
# Author: Frauke Blossey
# Start @ 12.03.2015

# get command line arguments:
require 'getoptlong'  

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

puts workingdir

# read Converter.config file to get all necessary parameters
File.open(workingdir+converter_config_file) do |f|
  f.each_line do |line|
    mainProj = line.gsub('MainProj')
  end
end

# call bake to get the necessary bakeOutput file
#def bake( mainProj, buildConfig, proj2Config )
#	cmd = "bake -m " + mainProj + " -b " + buildConfig + " -p " + proj2Config + " --printConverter"
#	status = system( cmd )
#	if status == false
#		abort 'Error while trying to call bake!'
#	end
#end



