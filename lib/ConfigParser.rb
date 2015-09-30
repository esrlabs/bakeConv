# Class ConfigParser
# Author: Frauke Blossey
# 23.03.2015

module BConv

  class ConfigParser
    
    def initialize(filename, projToConvert, debugMode)
      @filename = filename
      @projToConvert = projToConvert
      @debugMode = debugMode
    end
    
    def readConfig
      begin
        mapping = []
        mappings = []
        i=0
        j=0
        bracket = false
        
        File.open(@filename) do |l|
           while(line = l.gets) != nil  
            if line.include?("{")
              mapping.push({})
              i = i+1
              mapping[i] = mapping[i-1].clone
              bracket = true
              lineNumber = l.lineno
            elsif line.include?("}")
              if bracket == true
                #if @projToConvert != "" && @projToConvert != mapping[i]['Proj2Convert']
                #  mapping[i] = {}
                #end
                
                mappings.push({})
                mappings[j] = mapping[i].clone
                
                mappings[j].each do |key,value|
                  raise "Error: Workspace parameter from Mapping in line #{lineNumber} is missing!" if mappings[j].has_key?('Workspace') == false
                  raise "Error: MainProj parameter from Mapping in line #{lineNumber} is missing!" if mappings[j].has_key?('MainProj') == false
                  raise "Error: BuildConfig parameter from Mapping in line #{lineNumber} is missing!" if mappings[j].has_key?('BuildConfig') == false
                  raise "Error: Proj2Convert parameter from Mapping in line #{lineNumber} is missing!" if mappings[j].has_key?('Proj2Convert') == false
                  raise "Error: OutputFile parameter from Mapping in line #{lineNumber} is missing!" if mappings[j].has_key?('OutputFile') == false
                  raise "Error: TemplateFile parameter from Mapping in line #{lineNumber} is missing!" if mappings[j].has_key?('TemplateFile') == false
                end
                j = j+1
              end
              mapping.delete_at(i)
              i = i-1
              bracket = false
            else
              getKeyValuePairs(line,mapping[i],lineNumber)
            end
          end
        end
        return 0, mappings
      rescue Exception => e
        puts e.message
        puts e.back_trace if @debugMode == true
        abort
      end
    end
    
    def getKeyValuePairs(line,hash,lineNumber)
      arr = []
      line.gsub!('\\','/')
      arr = line.split("=")
      
      if (arr.length == 2)
        if arr[0].strip[0] != "#"
          comPos = arr[1].index("#")
          arr[1] = arr[1][0..comPos-1] if comPos != nil
          hash.store(arr[0].strip,arr[1].strip)
          raise "Error: Parameter in #{File.basename(@filename)} from Mapping in line #{lineNumber} is missing!" if arr[0].strip == ""
        end
      elsif arr[1] == ""
        hash.store(arr[0].strip,"")
      end
      return hash
    end
    
  end
  
end    

=begin      
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
                  if ar[0].strip[0] != "#"
                    comPos = ar[1].index("#")
                    ar[1] = ar[1][0..comPos-1] if comPos != nil
                   mapping.store(ar[0].strip,ar[1].strip)
                  end
                elsif ar[1] == ""
                  mapping.store(ar[0].strip,"")
                end
                
                if line.match(/^}$/)
                  raise "Error: Workspace parameter from Mapping in line #{lineNumber} is missing!" if mapping.has_key?('Workspace') == false
                  raise "Error: MainProj parameter from Mapping in line #{lineNumber} is missing!" if mapping.has_key?('MainProj') == false
                  raise "Error: BuildConfig parameter from Mapping in line #{lineNumber} is missing!" if mapping.has_key?('BuildConfig') == false
                  raise "Error: Proj2Convert parameter from Mapping in line #{lineNumber} is missing!" if mapping.has_key?('Proj2Convert') == false
                  raise "Error: OutputFile parameter from Mapping in line #{lineNumber} is missing!" if mapping.has_key?('OutputFile') == false
                  raise "Error: TemplateFile parameter from Mapping in line #{lineNumber} is missing!" if mapping.has_key?('TemplateFile') == false
                  
                  #raise "Error: Parameter in #{File.basename(@filename)}, Mapping line #{lineNumber} is missing!" if ar[0].strip == ""
                  
                  if @projToConvert != "" && @projToConvert != mapping['Proj2Convert']
                    mapping = {}
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
          return 0, mappings
        end

      rescue Exception => e
        puts e.message
        puts e.back_trace if @debugMode == true
        abort
      end
    end
=end        



