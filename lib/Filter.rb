# Class Filter: provides function for filtering special values from hash 
# Author: Frauke Blossey
# 06.08.2015

require_relative 'Util'

module BConv
  
  class Filter
    
    def self.hashFilter(keySearched, doFilter, hash)
      hash.each do |key, value|
        if keySearched == "GMOCK_FILTER"
          value.each { |elm| value.delete(elm) if elm.match(/\/?gmock\/?/) }
        elsif keySearched == "DEPENDENCIES_FILTER"  
          if doFilter == "true"
            hash.delete(key) if key == "BAKE_DEPENDENCIES"
          else
            hash.delete(key) if key == "BAKE_DEPENDENCIES_FILTERED"
          end
        end          
      end
            
      if keySearched == "DEPENDENCIES_FILTER"
        hvalues = []
        if doFilter == "false"
          hash["BAKE_DEPENDENCIES"].each { |v| hvalues << v }
          hash.store("DEPENDENCIES_FILTER", hvalues)
          hash.delete("BAKE_DEPENDENCIES")
        else  
          hash["BAKE_DEPENDENCIES_FILTERED"].each { |v| hvalues << v }
          hash.store("DEPENDENCIES_FILTER", hvalues)
          hash.delete("BAKE_DEPENDENCIES_FILTERED")
        end
      end 
      return hash
    end
    
  end
  
end