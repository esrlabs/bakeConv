# Class Bake
# Author: Frauke Blossey
# 24.03.2015

require_relative 'Converter'

module BConv

  class Bake
  
    def initialize(map, setMock, configFile)
      @map = map
      @setMock = setMock
      @configFile = configFile
    end
    
     def run
     bakeLines = ''
      #@map['Workspace'].gsub!(/[\[,\]']+/,'')
#      wArr = Util.strToArray('Workspace', @map)
##      workspace = ''
#      for i in (0..wArr.length-1)
#        workspace << (' -w ' + wArr[i])
#      end
      
#      if @setMock == false
#        bakeLines = `bake        -b #{@map['BuildConfig']} -m #{@map['MainProj']} #{workspace} -p #{@map['Proj2Convert']}`
#      else
#        cmd = "../bakeMock/bakeMock/bakeMock.rb"
#        bakeLines = `ruby #{cmd} -b #{@map['BuildConfig']} -m #{@map['MainProj']} #{workspace} -p #{@map['Proj2Convert']}`
#      end
      
      cmd = @setMock ? ['ruby','../../../bakeMock/bakeMock/bakeMock.rb'] : ['bake']
      cmd << '-b' << @map['BuildConfig']
      cmd << '-m' << @map['MainProj']
      cmd << '-p' << @map['Proj2Convert']
      Util.strToArray('Workspace', @map).each { |w| cmd << '-w' << w }

      Dir.chdir(File.dirname(@configFile)) do      
        bakeLines = `#{cmd.join(' ')}`
      end
      
      abort 'Error while trying to call bake!' unless $?.success?
      return bakeLines
    end
    
    def getHash(bakeLines)
      startLabel = false
      b_hash = {}
      key = ""
      value = []
      idx = 0
      bakeLines.each_line do |l|
        if l.include?('START_MAPPING') && l[0] != " "
          startLabel = true
          bLines = bakeLines.lines.to_a[(idx+1)...-1].join
          bLines.each_line do |line|
            if (line[0] == " ") && (line[1] != " ") && (line.include?("BAKE_"))
              key = ""
              value = []
              key = line.strip
            elsif line[0..1] == "  " && (line[2] != " ") && (line.include?("BAKE_") == false) && (line.include?("END_MAPPING") == false)
              value << line.strip if value != nil
              value = line.strip if value == nil
              b_hash.store(key,value)
            elsif line[0] != " " && line.include?("BAKE_")
              abort 'Error: 1 blank is necessary in front of a \'BAKE_\' keyword in the bake output file!'
            elsif line[0..1] == "  " && line.include?("BAKE_")
              abort 'Error: Just 1 blank is allowed in front of a \'BAKE_\' keyword in the bake output file!'
            elsif line[0..1] != "  " && (line.include?("BAKE_") == false) && (line.include?("END_MAPPING") == false)
              abort 'Error: 2 blanks are necessary in front of a bake keyword value in the bake output file OR there is no END_MAPPING defined!'
            elsif line[0..2] == "   " && (line.include?("BAKE_") == false) && (line.include?("END_MAPPING") == false)
              abort 'Error: Just 2 blanks are allowed in front of a bake keyword value in the bake output file!'
            elsif line.include?("END_MAPPING") && line[0] != " "
              break
            elsif line.include?("END_MAPPING") && line[0] == " "
              abort 'Error: blanks in front of END_MAPPING'
            end
          end
        elsif l.include?("START_MAPPING") && l[0] == " "
          abort 'Error: blanks in front of START_MAPPING'
        end
        idx += 1
      end
      if startLabel == false
        abort 'Error: START_MAPPTING couldn\'t be found in the bake output file!'
      else
        return b_hash
      end
    end
    
  end

end