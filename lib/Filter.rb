# Class Filter: provides function for filtering special values from hash 
# Author: Frauke Blossey
# 06.08.2015

require_relative 'Util'

module BConv
  
  class Filter
    
    def self.hashFilter(keySearched, forFiltering, hash)      
      forFilteringArr = forFiltering[1..-2].split(",").map {|elm| elm.strip}
      hash.each do |key, value|
        if key == keySearched.split("EXCLUDE_")[1]
          forFilteringArr.each do |elm|
            value.each do |val|
              if val.include?(elm)
                value.delete(val)
              end
            end
          end
        end
      end 
      return hash
    end
    
  end
  
end