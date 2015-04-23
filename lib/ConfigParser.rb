# Class ConfigParser
# Author: Frauke Blossey
# 23.03.2015

module BConv

  class ConfigParser
    
    def initialize(filename)
      @filename = filename
    end
    
    def readConfig
      begin
        File.open(@filename) do |l|
          mappings = []
          while(line = l.gets) != nil
            mapping = {}
            ar = []
            if line.include?("Mapping")
              while(line = l.gets) != nil
                line.gsub!('\\','/')
                ar = line.split(" = ")
                mapping.store(ar[0].strip,ar[1].strip) if ar.length == 2
                if line.include?("}")   # hier noch Fehlerabfrage
                  mappings << mapping
                  break
                end
              end
            #else
              #raise SyntaxError, 'Did you forget the ''Mapping'' keyword?'
            end
          end
          return mappings
        end
      rescue Exception => e
        abort e.message
      end
    end
    
  end
  
end    



