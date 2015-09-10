# Class File (extended with 'isAbsolute' method)
# Author: Frauke Blossey
# 14.04.2015

class File
  
  def self.isAbsolute?(filename) 
    return File.expand_path(filename) == filename
  end
  
end