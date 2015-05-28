# Class Bake
# Author: Frauke Blossey
# 24.03.2015

require_relative 'Converter'

module BConv

  # class ParserException < Exception
  # end

  class Bake
    
    #enums
    START_MAPPING = 1
    END_MAPPING = 2
    BEFORE_MAPPING = 3
    VAR = 4
  
    def initialize(map, setMock, configFile)
      @map = map
      @setMock = setMock
      @configFile = configFile
    end
    
    def run
      bakeLines = ''
      cmd = @setMock ? ['ruby','C:/_dev/projects/bakeMock/bakeMock/bakeMock.rb'] : ['bake']
      cmd << '-b' << @map['BuildConfig']
      cmd << '-m' << @map['MainProj']
      cmd << '-p' << @map['Proj2Convert']
      Util.strToArray('Workspace', @map).each { |w| cmd << '-w' << w }

      Dir.chdir(File.dirname(@configFile)) do      
        bakeLines = `#{cmd.join(' ')}`
      end
      
      abort "Error while trying to call bake!" unless $?.success?
      return bakeLines
    end
    
    def getHash(bakeLines)
      b_hash = {}
      key = ""
      value = []
      state = Bake::BEFORE_MAPPING
      
      bakeLines.each_line do |line|
        if line.start_with?("  ") && line[2] != " "
            if state == Bake::VAR
              value << line.strip if value != nil
              value = line.strip if value == nil
              b_hash.store(key,value)
             
            end
        elsif line.start_with?(" ") && line[1] != " "
          if state == Bake::START_MAPPING || state == Bake::VAR
            key = ""
            value = []
            key = line.strip
            
            # if key != "BAKE_NAME" && key != "BAKE_SRC" && key != "BAKE_HEADER"
              # state = Bake::START_MAPPING           
            # else
              state = VAR
            #end
          end
        #elsif line.start_with?("") && !line.match("START_MAPPING") && !line.match("END_MAPPING")
        #  puts "Error: Nothing else than START_MAPPING and END_MAPPING starting without blanks!"
        else
          if line.match("START_MAPPING") && line[0] != " "
            # if state != Bake::BEFORE_MAPPING
              # abort "Error!" 
            # end
            state = Bake::START_MAPPING
          elsif line.match("END_MAPPING")
            state = Bake::END_MAPPING
          end
        end
      end
      
      if state != Bake::END_MAPPING
        puts "Error: There is a problem with END_MAPPING. No output file could be generated!"
        return nil
       #raise ParseException.new("END_MAPPING missing") 
      end
       
     # begin
       # ...
     # rescue ParseException
       # exit(-1)
     # end
        
      return b_hash
    end
    
  end

end