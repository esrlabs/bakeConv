# Class Converter
# Author: Frauke Blossey
# 24.03.2015

require_relative 'Util'

module BConv
 
  class Converter
  
    def initialize(map, configFile)
      @configFile = configFile
      @map = map
    end
    
    def convert
      outputfilename = Util.makeAbsolute(@map['OutputFileName'], @configFile)
      templatefilename = Util.makeAbsolute(@map['TemplateFile'], @configFile)

      begin
      File.open(outputfilename, 'w') do |fout|
        File.open(templatefilename) do |fread|
          File.readlines(fread).each do |line|
            wroteLine = false
            @map.keys.each do |key|               

              if line.include?(key.to_s) && @map[key].include?(".txt")
                preAndPostfix = line.scan(/(.*)\$\$\(#{key}\)(.*)/)
                if preAndPostfix.length == 1
                  prefix = preAndPostfix[0][0]
                  postfix = preAndPostfix[0][1]
                end
                
                filename = Util.makeAbsolute(@map[key], @configFile)
                File.open(filename) do |fr|
                  File.readlines(fr).each do |l|
                    @map.keys.each do |k|
                      wroteLine = findAndReplace(k, l, fout, prefix, postfix)
                      break if wroteLine == true
                    end
                    if wroteLine == false 
                      l.strip!
                      l = prefix + l + postfix + "\n"
                      fout.write(l)
                    end
                  end
                end
              elsif (@map[key][0] == "[") && (@map[key][-1] == "]")
                @map.store(key,Util.strToArray(key, @map))
                wroteLine = findAndReplace(key, line, fout, "", "")
              elsif line.include?(key.to_s)
                wroteLine = findAndReplace(key, line, fout, "", "")
              end
            end
          
           if wroteLine == false 
            fout.write(line)
           end
                                   
          end
        end
      end
      rescue Exception => msg
        puts msg
      end
    end
  
    def findAndReplace(key, line, fout, prefix, postfix)
      wroteLine = false
      found = line.scan(/(.*)\$\$\(#{key}\)(.*)/)
    
      if found.length == 1
        pre = found[0][0]
        post = found[0][1]

        if @map[key].length != 0 && @map[key].kind_of?(Array) == true
          @map[key].each do |val|
            line = prefix + pre + val.to_s + post + postfix + "\n"
            fout.write(line)
            wroteLine = true
          end
        else
          line = prefix + pre + @map[key] + post + postfix + "\n"
          fout.write(line)
          wroteLine = true
        end
      elsif line.include?("/\$\$\(#{key}\)/") && found.length == 0
        line.gsub!(/\$\$\(#{key}\)/, @map[key].to_s)
        fout.write(line)
        wroteLine = true
      end
      return wroteLine
    end

  end

end