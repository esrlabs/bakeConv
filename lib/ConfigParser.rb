# Class ConfigParser
# Author: Frauke Blossey
# 23.03.2015

require_relative 'Util'

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
        bracket = false
        i=0
        j=0
        
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
                if @projToConvert != "" && @projToConvert != mapping[i]['Proj2Convert']
                  #do nothing and continue
                  bracket = false
                elsif @projToConvert != "" && @projToConvert == mapping[i]['Proj2Convert']
                  mappings.push({})
                  mappings[j] = mapping[i].clone
                  break
                else
                  mappings.push({})
                  mappings[j] = mapping[i].clone
                  bracket = false
                end
                
                if mappings.length != 0
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
              end
              mapping.delete_at(i)
              i = i-1
              bracket = false
            else
              getKeyValuePairs(line,mapping[i],lineNumber)
            end
          end
          replaceWorkspaceElmInPath(mappings)
        end
        return 0, mappings
      rescue Exception => e
        puts e.message
        #puts e.back_trace if @debugMode == true
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
    
    def replaceWorkspaceElmInPath(mappings)
      for j in 0..(mappings.length-1)
        workspaceArr = Util.strToArray('Workspace',mappings[j])    
        mappings[j].each do |key,value|
          match = value.match(/Workspace\s*\[\s*(\d+)\s*\]/)
          if match != nil
            value.gsub!(/Workspace\s*\[\s*(\d+)\s*\]/,workspaceArr[match[1].to_i])
          end
        end
      end
    end
    
  end
  
end



