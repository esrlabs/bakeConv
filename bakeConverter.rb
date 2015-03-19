# bake to converter
# Author: Frauke Blossey
# Start @ 12.03.2015

require 'getoptlong'
  
#------------------------------------------------------------------------------------------------------
# Get command line arguments:
#------------------------------------------------------------------------------------------------------

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

fileName = workingdir + converter_config_file


#------------------------------------------------------------------------------------------------------
# Functions for:
# - reading necessary data from Converter.config file and store it into a hash
# - call bake and get the BakeOutput file
# - reading BakeOutput file and store the necessary data into a hash
#------------------------------------------------------------------------------------------------------

def getHashFromConfigFile(fileName, searchFor)
  File.open(fileName) do |l|
    while(line = l.gets) != nil
      hash = {}
      ar = []
      if line.include?(searchFor)
        while(line = l.gets) != nil
          ar = line.split(" = ")
          hash.store(ar[0].strip,ar[1].strip) if ar.length == 2
          break if line.include?("}")
        end
        return hash
      end
    end
  end
end

#------------------------------------------------------------------------------------------------------

def callBake(bakeHash)
	cmd = "bake -m " + bakeHash['MainProj'] + " -b " + bakeHash['BuildConfig'] + " -p " + bakeHash['Proj2Convert'] + " --printConverter"
#	status = system( cmd )
#	if status == false
#		abort 'Error while trying to call bake!'
#	end
   puts cmd
    return "Files/\BakeOutput.txt"
end

#------------------------------------------------------------------------------------------------------

def getBakeHash(fileName)
  File.open(fileName) do |l|
    b_hash = {}
    while(line = l.gets) != nil
      arr = []
      if line.include?("BAKE_NAME")
        while(line = l.gets) != nil
          arr << line.strip
          break if line.include?("}")
        end
        arr[-1] = arr[-1].chomp("}")
        b_hash["BAKE_NAME"] = arr
      end    
    
      if line.include?("BAKE_SRC")
        while(line = l.gets) != nil
          arr << line.strip()
          break if line.include?("}")
        end
        arr[-1] = arr[-1].chomp("}")
        b_hash["BAKE_SRC"] = arr
      end
      
      if line.include?("BAKE_HEADER")
        while(line = l.gets) != nil
          arr << line.strip
          break if line.include?("}")
        end
        arr[-1] = arr[-1].chomp("}")
        b_hash["BAKE_HEADER"] = arr
      end
    end
    return b_hash
  end
end

#------------------------------------------------------------------------------------------------------
# Read necessary data from Converter.config for the bake call.
# Call bake and get BakeOutput file. Read out the BakeOutput file and create a hash with the necessary data.
#------------------------------------------------------------------------------------------------------

bakeHash = getHashFromConfigFile(fileName, "Bake")

bakeFileName = callBake(bakeHash)
bakeHashFromBake = getBakeHash(workingdir+bakeFileName)

#puts bakeHash
#puts bakeHashFromBake

#------------------------------------------------------------------------------------------------------
# ToDo:
#------------------------------------------------------------------------------------------------------

def convertProcess(fileName, workingdir, bakeHashFromBake)
  File.open(fileName) do |l|
    while(line = l.gets) != nil
      hash = {}
      ar = []
      if line.include?("Mapping")
        while(line = l.gets) != nil
          ar = line.split(" = ")
          hash.store(ar[0].strip,ar[1].strip) if ar.length == 2
          break if line.include?("}")
        end
        doMapping(hash, workingdir, bakeHashFromBake)
      end
    end
  end
end

def doMapping(hash, workingdir, bakeHashFromBake)
  mainTmpFile = workingdir + hash['InputDir'] + "\\"+ hash['TemplateFile']
  mainTmpFileReplaced = workingdir + hash['InputDir'] + "\\"+ hash['OutputFileName']
  
  File.open(mainTmpFileReplaced, 'w') do |fout|  
    File.open(mainTmpFile) do |f|
      File.readlines(f).each do |line|
        line.gsub!(/\$\$\(BAKE_NAME\)/, bakeHashFromBake['BAKE_NAME'][0].to_s)

        sourceResult = line.scan(/(.*)\$\$\(BAKE_SRC\)(.*)/)
        headerResult = line.scan(/(.*)\$\$\(BAKE_HEADER\)(.*)/)
        
        hash.keys.each do |k|
          if line.match(k)
            searchFor = "\$\$\("+ k + "\)"
            line.gsub!(searchFor, hash[k])
          end 
        end
        
        if sourceResult.length > 0
          prefix = sourceResult[0][0]
          postfix = sourceResult[0][1]
          bakeHashFromBake['BAKE_SRC'].each do |src|
              fout.write(prefix + " " + src + " " + postfix + "\n") if prefix != ""
              fout.write(prefix + src + postfix + "\n") if prefix == ""
          end
        elsif headerResult.length > 0
          prefix = headerResult[0][0]
          postfix = headerResult[0][1]
          bakeHashFromBake['BAKE_HEADER'].each do |hdr|
            fout.write(prefix + " " + hdr + " " + postfix + "\n") if prefix != ""
            fout.write(prefix + hdr + postfix + "\n") if prefix == ""
          end
        else
            fout.write(line)
        end
      end
    end
  end
end

convertProcess(fileName, workingdir, bakeHashFromBake)











