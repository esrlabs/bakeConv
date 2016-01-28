# Class Bake
# Author: Frauke Blossey
# 24.03.2015

require_relative 'Converter'

module BConv

  class Bake

    START_INFO = 1
    END_INFO = 2
    BEFORE_INFO = 3
    VAR = 4
  
    def initialize(map, setMock, configFile, debugMode)
      @map = map
      @setMock = setMock
      @configFile = configFile
      @debugMode = debugMode
    end
    
    def run
      bakeLines = ''
      begin
      cmd = @setMock ? ['ruby','C:/_dev/projects/bakeMock/bakeMock/bakeMock.rb'] : ['bake']
      cmd << '-b' << @map['BuildConfig']
      cmd << '-m' << @map['MainProj']
      cmd << '-p' << @map['Proj2Convert']
      cmd << '--conversion_info'
      Util.strToArray('Workspace', @map).each { |w| cmd << '-w' << w }

      Dir.chdir(File.dirname(@configFile)) do   
        bakeLines = `#{cmd.join(' ')}`
      end
      
      rescue Exception => e
        puts e.message
        puts e.back_trace if @debugMode == true
        abort
      end
            
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
            state = VAR
          end
        else
          if line.match("START_INFO") && line[0] != " "
            state = Bake::START_INFO
          elsif line.match("END_INFO")
            state = Bake::END_INFO
          end
        end
      end
      
      if state != Bake::END_INFO
        puts "Error: There is a problem with END_INFO. No output file could be generated!"
        return nil
      end
        
      return b_hash
    end
    
  end

end