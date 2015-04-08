# Class Bake
# Author: Frauke Blossey
# 24.03.2015

module BConv

  class Bake
  
    def initialize
    end
    
     def run(map)
      #cmd = "bake -m " + map['MainProj'] + " -b " + map['BuildConfig'] + " -p " + map['Proj2Convert']
      cmd = "..\\bakeTest\\bakeTester\\bakeTester.rb"
      status = system("ruby", cmd, "-m", map['MainProj'], "-b", map['BuildConfig'], "-p", map['Proj2Convert'], "--testcase", "t_bakeKW_blank_missing")
      if status == false
        abort 'Error while trying to call bake!'
      end
      return  map['MainProj'] + "\\" + map['BuildConfig'] + "\\bakeOutput.txt"
    end
    
    def getHash(bakefilename)
      startLabel = false
      endLabel = false
      b_hash = {}
      File.open(bakefilename) do |l|
        while(line = l.gets) != nil
          if line.include?("START_MAPPING")
            startLabel = true
            while(line = l.gets) != nil
              if (line[0] == " ") && (line[1] != " ") && (line.include?("BAKE_"))
                key = ""
                value = []
                key = line.strip
              elsif line[0..1] == "  " && (line.include?("BAKE_") == false)
                value << line.strip if value != nil
                value = line.strip if value == nil
                b_hash.store(key,value)
              elsif line[0] != " " && line.include?("BAKE_")
                abort 'Error: 1 blank is necessary in front of a \'BAKE_\' keyword in the bake output file!'
              elsif line[0..1] == "  " && line.include?("BAKE_")
                abort 'Error: Just 1 blank is allowed in front of a \'BAKE_\' keyword in the bake output file!'
              elsif line[0..1] != "  " && (line.include?("BAKE_") == false)
                abort 'Error: 2 blanks are necessary in front of a bake keyword value in the bake output file!'
              elsif line[0..2] == "   " && (line.include?("BAKE_") == false)
                abort 'Error: Just 2 blanks are allowed in front of a bake keyword value in the bake output file!'
              elsif line.include?("END_MAPPING")
                endLabel = true
                break
              end
            end
          end
        end
      end
      if startLabel == false
        abort 'Error: START_MAPPTING couldn\'t be found in the bake output file!'
      elsif endLabel == false
        abort 'Error: END_MAPPTING couldn\'t be found in the bake output file!'
      else
        return b_hash
      end
    end
    
  end

end