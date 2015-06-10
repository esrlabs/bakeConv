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
    map[key][1..-2].split(",").map {|elem| elem.strip}
  end

end