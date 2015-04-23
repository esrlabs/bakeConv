# Class Util (contains utility methods)
# Author: Frauke Blossey
# 15.04.2015

require_relative 'File_ext'

class Util
  
  def self.makeAbsolute(file, configFile)
    if File.isAbsolute?(file)
      outputfilename = file
    else
      outputfilename = File.dirname(configFile) + "/" + file
    end
  end
  
  def self.strToArray(key, map)
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