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
            setEndLabel = false
            if line.include?("Mapping")
              while(line = l.gets) != nil
                line.gsub!('\\','/')
                ar = line.split(" = ")
                mapping.store(ar[0].strip,ar[1].strip) if ar.length == 2
                if line.include?("}")
                  raise 'Error: Workspace parameter is missing!' if mapping.has_key?('Workspace') == false
                  raise 'Error: MainProj parameter is missing!' if mapping.has_key?('MainProj') == false
                  raise 'Error: BuildConfig parameter is missing!' if mapping.has_key?('BuildConfig') == false
                  raise 'Error: Proj2Convert parameter is missing!' if mapping.has_key?('Proj2Convert') == false
                  raise 'Error: OutputFileName parameter is missing!' if mapping.has_key?('OutputFileName') == false
                  raise 'Error: TemplateFile parameter is missing!' if mapping.has_key?('TemplateFile') == false
                  mappings << mapping
                  setEndLabel = true
                  break
                elsif line.include?("Mapping")
                  raise 'Error: end label } is missing!'
                end
              end
              raise 'Error: end label } is missing!' if setEndLabel == false
            elsif line.include?("Workspace")
              raise 'Error: Mapping keyword is missing?'
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



