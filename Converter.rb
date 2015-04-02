# Class Converter
# Author: Frauke Blossey
# 24.03.2015

module BConv
 
  class Converter
  
    def initialize(workingdir)
      @workingdir = workingdir
    end
    
    def convert(map)
      templatefilename = @workingdir + map['MainProj'] + "\\" + map['TemplateFile']
      outputfilename = @workingdir + map['MainProj'] + "\\" + map['OutputFileName']

      begin
      File.open(outputfilename, 'w') do |fout|
        File.open(templatefilename) do |fread|
          File.readlines(fread).each do |line|
            wroteLine = false
            map.keys.each do |key|               
              
              if line.include?(key.to_s) && map[key].include?(".txt")
                filename = @workingdir + map['MainProj'] + "\\" + map[key]
                File.open(filename) do |fr|
                  File.readlines(fr).each do |l|
                    map.keys.each do |k|
                      wroteLine = findAndReplace(map, k, l, fout)
                      break if wroteLine == true
                    end
                    if wroteLine == false 
                      fout.write(l)
                    end
                  end
                end
              elsif (map[key][0] == "[") && (map[key][-1] == "]")
                map.store(key,strToArray(map, key))
                wroteLine = findAndReplace(map, key, line, fout)
              elsif line.include?(key.to_s)
                wroteLine = findAndReplace(map, key, line, fout)
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
  
    def findAndReplace(map, key, line, fout)
      wroteLine = false
      found = line.scan(/(.*)\$\$\(#{key}\)(.*)/)
    
      if found.length == 1
        prefix = found[0][0]
        postfix = found[0][1]

        if map[key].length != 0 && map[key].kind_of?(Array) == true
          map[key].each do |val|
            line = prefix + val.to_s + postfix + "\n"
            fout.write(line)
            wroteLine = true
          end
        else
          line = prefix + map[key] + postfix + "\n"
          fout.write(line)
          wroteLine = true
        end
      elsif line.include?("/\$\$\(#{key}\)/") && found.length == 0
        line.gsub!(/\$\$\(#{key}\)/, map[key].to_s)
        fout.write(line)
        wroteLine = true
      end
      return wroteLine
    end
    
    def strToArray(map, key)
      arrValue = []
      arr = map[key].split(",")
     
      tmp = arr[0].split("[")
      arr[0] = tmp[1]
      tmp = arr[-1].split("]")
      arr[-1] = tmp[0]
    
      arr.each do |elm|
	    elm  = elm.strip
	    arrValue << elm
      end
      return arrValue
    end
  end

end