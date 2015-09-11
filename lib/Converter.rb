# Class Converter
# Author: Frauke Blossey
# 24.03.2015

require_relative 'Util'

module BConv
 
  class Converter
  
    def initialize(map, configFile, debugMode)
      @configFile = configFile
      @map = map
      @debugMode = debugMode
    end
    
    def convert
      outputfilename = Util.makeAbsolute(@map['OutputFile'], @configFile)
      templatefilename = Util.makeAbsolute(@map['TemplateFile'], @configFile)

      lineIdx = 0
      tmpLineIdx = 0
      set = true
     
      @map.delete_if{|k,_| (k=="EXCLUDE_BAKE_DEPENDENCIES" || k=="EXCLUDE_BAKE_SOURCES" || k=="EXCLUDE_BAKE_INCLUDES") } #not useful anymore
      
      begin
      File.open(outputfilename, 'w') do |fout|
        File.open(templatefilename) do |fread|
          File.readlines(fread).each do |line|
            lineIdx += 1
            wroteLine = false
            
            @map.keys.each do |key|
              if line.include?(key.to_s) && @map[key].include?(".txt")
                preAndPostfix = line.scan(/(.*)\$\$\(#{key}\)(.*)/)
                preAndPostfixOpt = line.scan(/(.*)\$OPTION\(#{key}\)(.*)/)
                
                if preAndPostfix.length == 1
                  prefix = preAndPostfix[0][0]
                  postfix = preAndPostfix[0][1]
                end
                #need some cosmetics!
                if preAndPostfixOpt.length == 1
                  prefix = preAndPostfixOpt[0][0]
                  postfix = preAndPostfixOpt[0][1]
                end
                
                filename = Util.makeAbsolute(@map[key], @configFile)
                raise "Error: Template file #{File.basename(filename)} is empty!" if File.zero?(filename)
                raise "Error: File #{File.basename(filename)} does not exist!" if !File.exist?(filename)
                
                File.open(filename) do |fr|
                  File.readlines(fr).each do |l|
                    tmpLineIdx += 1
                    @map.keys.each do |k|
                      wroteLine = findAndReplace(k, l, fout, prefix, postfix)
                      break if wroteLine == true
                    end                   
                    
                    if wroteLine == false 
                      l.strip!
                      l = prefix + l + postfix + "\n"
                      m = l.match(/\$\$\((.*)\)/)
                      opt = l.match(/\$OPTION\((.*)\)/)
                      raise "Error: Key $$(#{m[1]}) in #{File.basename(filename)}, line #{tmpLineIdx.to_s} wasn\'t replaced!" if m
                      puts "Info: Key $OPTION(#{opt[1]}) in #{File.basename(filename)}, line #{tmpLineIdx.to_s} wasn\'t replaced!" if opt  
                      fout.write(l)
                      set = false
                    end
                  end
                end
              elsif (@map[key][0] == "[") && (@map[key][-1] == "]")
                @map.store(key,Util.strToArray(key, @map))
                wroteLine = findAndReplace(key, line, fout, "", "")
                break
              elsif line.match(/\$\$\(#{key}\)/)
                wroteLine = findAndReplace(key, line, fout, "", "")
                break
              elsif line.match(/\$OPTION\(#{key}\)/)
                wroteLine = findAndReplace(key, line, fout, "", "")
                break
              end
            end
            
            if wroteLine == false
              if set == true
                m = line.match(/\$\$\((.*)\)/)
                opt = line.match(/\$OPTION\((.*)\)/)
                raise "Error: Key $$(#{m[1]}) in #{File.basename(templatefilename)}, line #{lineIdx.to_s} wasn\'t replaced!" if m
                puts "Info: Key $OPTION(#{opt[1]}) in #{File.basename(templatefilename)}, line #{lineIdx.to_s} wasn\'t replaced!" if opt
                fout.write(line)
              end
              set = true
            end 
          end
        end
      end
      raise "Error: Output file #{File.basename(outputfilename)} is empty!" if File.zero?(outputfilename)
      raise "Error: Template file #{File.basename(templatefilename)} is empty!" if File.zero?(templatefilename)
      rescue Exception => e
        puts e.message
        puts e.back_trace if @debugMode == true
        abort
      end
      return 0
    end
  
    def findAndReplace(key, line, fout, prefix, postfix)
      wroteLine = false
      found = line.scan(/(.*)\$\$\(#{key}\)(.*)/)
      foundOpt = line.scan(/(.*)\$OPTION\(#{key}\)(.*)/)
      
      found = foundOpt if (found.length==0 && foundOpt.length!=0)
      
      if found.length == 1
        pre = found[0][0]
        post = found[0][1]
        if @map[key].kind_of?(Array)
          @map[key].each do |val|
            line = prefix + pre + val.to_s + post + postfix + "\n"
            fout.write(line)
          end
          wroteLine = true
        else
          line = prefix + pre + @map[key] + post + postfix + "\n"
          fout.write(line)
          wroteLine = true
        end
      elsif line.include?("/\$\$\(#{key}\)/") && found.length == 0
        line.gsub!(/\$\$\(#{key}\)/, @map[key].to_s)
        fout.write(line)
        wroteLine = true
      elsif line.include?("/\$OPTION\(#{key}\)/") && found.length == 0
        line.gsub!(/\$OPTION\(#{key}\)/, @map[key].to_s)
        fout.write(line)
        wroteLine = true
      end
      return wroteLine
    end

  end

end