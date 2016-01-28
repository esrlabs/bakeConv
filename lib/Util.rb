# Class Util (contains utility methods)
# Author: Frauke Blossey
# 15.04.2015

require_relative 'File_ext'

class Util
  
  def self.makeAbsolute(file, pwd)
    if File.isAbsolute?(file)
      outputfilename = file
    else
      #outputfilename = File.dirname(pwd) + "/" + file
      outputfilename = File.expand_path(file)
    end
    return outputfilename    
  end
  
  def self.strToArray(key, map)
    map[key][1..-2].split(",").map {|elem| elem.strip}
  end
  
  def self.truncateStr(refStr, toTruncStr)
    posOfSlash = refStr.index("/")
    while posOfSlash != nil && toTruncStr[0..1] != ".."
      if refStr[0..posOfSlash] == toTruncStr[0..posOfSlash]
        toTruncStr = toTruncStr[posOfSlash+1..-1]
        refStr = refStr[posOfSlash+1..-1]
      else
        break
      end
      posOfSlash = refStr.index("/")
    end
    return toTruncStr
  end

end