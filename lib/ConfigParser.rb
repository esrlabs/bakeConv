# Class ConfigParser
# Author: Frauke Blossey
# 23.03.2015

module BConv

  class ConfigParser
    
    def initialize(filename, projToConvert)
      @filename = filename
      @projToConvert = projToConvert
    end
    
    def readConfig
      begin
        File.open(@filename) do |l|
          mappings = []
          mapForProj = {} 
          while(line = l.gets) != nil
            mapping = {}
            ar = []
            setEndLabel = false
            if line.match(/^Mapping/)
              lineNumber = l.lineno
              while(line = l.gets) != nil
                line.gsub!('\\','/')
                ar = line.split("=")
                
                if (ar.length == 2)
                  comPos = ar[1].index("#")
                  ar[1] = ar[1][0..comPos-1] if comPos != nil
                  mapping.store(ar[0].strip,ar[1].strip)
                elsif ar[1] == ""
                  mapping.store(ar[0].strip,"")
                end
                
                if line.match(/^}$/)
                  raise "Error: Workspace parameter from Mapping in line #{lineNumber} is missing!" if mapping.has_key?('Workspace') == false
                  raise "Error: MainProj parameter from Mapping in line #{lineNumber} is missing!" if mapping.has_key?('MainProj') == false
                  raise "Error: BuildConfig parameter from Mapping in line #{lineNumber} is missing!" if mapping.has_key?('BuildConfig') == false
                  raise "Error: Proj2Convert parameter from Mapping in line #{lineNumber} is missing!" if mapping.has_key?('Proj2Convert') == false
                  raise "Error: OutputFileName parameter from Mapping in line #{lineNumber} is missing!" if mapping.has_key?('OutputFileName') == false
                  raise "Error: TemplateFile parameter from Mapping in line #{lineNumber} is missing!" if mapping.has_key?('TemplateFile') == false
                  
                  if @projToConvert.length != 0
                    @projToConvert.each do |val|
                      if val == mapping['Proj2Convert']
                        mappings << mapping
                      end
                    end
                  else
                    mappings << mapping
                  end
                  
                  setEndLabel = true
                  break
                elsif line.include?("Mapping")
                  raise "Error: end label } from Mapping in line #{lineNumber} is missing!"
                end
              end
              raise "Error: end label } from Mapping in line #{lineNumber} is missing!" if setEndLabel == false
            elsif line.match(/^( *)Workspace/)
              lineNumber = l.lineno
              raise "Error: Mapping keyword in front of line #{lineNumber} is missing?"
            end
          end
          return mappings
        end
      rescue Exception => e
        puts e.message
        #puts e.back_trace
        abort
      end
    end
    
  end
  
end    



