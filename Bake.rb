# Class Bake
# Author: Frauke Blossey
# 24.03.2015

module BConv

  class Bake
  
    def initialize
    end
    
     def run(map)
      cmd = "bake -m " + map['MainProj'] + " -b " + map['BuildConfig'] + " -p " + map['Proj2Convert'] + " --printConverter"
#	  status = system( cmd )
#      if status == false
#        abort 'Error while trying to call bake!'
#      end
      return "bsp\\mainApplication\\BakeOutput.txt"
    end
    
    def getHash(bakefilename)
      File.open(bakefilename) do |l|
        b_hash = {}
        while(line = l.gets) != nil
          if line.include?("START_MAPPING")
            while(line = l.gets) != nil
              if (line[0] == " ") && (line[1] != " ")
                key = ""
                value = []
                key = line.strip
              elsif line[0..1] == "  "
                value << line.strip if value != nil
                value = line.strip if  value == nil
                b_hash.store(key,value)
              elsif line.include?("END_MAPPING")
                break
              end
            end
            return b_hash
          end
        end
      end
    end
    
  end

end