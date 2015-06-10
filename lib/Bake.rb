# Class Bake
# Author: Frauke Blossey
# 24.03.2015

require_relative 'Converter'

module BConv

  # class ParserException < Exception
  # end

  class Bake
    
    #enums
    START_INFO = 1
    END_INFO = 2
    BEFORE_INFO = 3
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
      cmd << '--conversion_info'
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
      state = Bake::BEFORE_INFO
      
      bakeLines.each_line do |line|
        if line.start_with?("  ") && line[2] != " "
            if state == Bake::VAR
              value << line.strip if value != nil
              value = line.strip if value == nil
              b_hash.store(key,value)
             
            end
        elsif line.start_with?(" ") && line[1] != " "
          if state == Bake::START_INFO || state == Bake::VAR
            key = ""
            value = []
            key = line.strip
            b_hash.store(key,value)
            
            # if key != "BAKE_INCLUDES" && key != "BAKE_SOURCES" && key != "BAKE_DEFINES"
              # state = Bake::START_INFO           
            # else
              state = VAR
            #end
          end
        #elsif line.start_with?("") && !line.match("START_INFO") && !line.match("END_INFO")
        #  puts "Error: Nothing else than START_INFO and END_INFO starting without blanks!"
        else
          if line.match("START_INFO") && line[0] != " "
            # if state != Bake::BEFORE_INFO
              # abort "Error!" 
            # end
            state = Bake::START_INFO
          elsif line.match("END_INFO")
            state = Bake::END_INFO
          end
        end
      end
      
      if state != Bake::END_INFO
        puts "Error: There is a problem with END_INFO. No output file could be generated!"
        return nil
       #raise ParseException.new("END_INFO missing") 
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