# Class PathAdapt (methods to adapt paths relative to the location of the e.g. CMakeLists file)
# Author: Frauke Blossey
# 04.08.2015

module BConv
  
  require_relative 'Util'
  
  class PathAdapt
    SLASH = "/"
    COLON = ":"
    
    def self.adapt_path(outputFilePath, bhash, pwd, debugMode)
      diffPathLevels, diffPathLevelsDown = 0, 0
      dir, diffUp = "", ""
      diffArr = []
      
      begin
      #splitOutputFile = File.expand_path(File.dirname(outputFilePath),File.dirname(pwd)).split("/") 
      splitOutputFile = File.expand_path(File.dirname(outputFilePath),pwd).split("/")
      splitProjMeta   = bhash['BAKE_PROJECTDIR'][0].split("/") if bhash['BAKE_PROJECTDIR'][0].include?("/") && bhash['BAKE_PROJECTDIR'] != nil
      #raise "Error: BAKE_PROJDIR is missing!" if bhash['BAKE_PROJECTDIR'] == nil
  
      if splitOutputFile.length > splitProjMeta.length
        diffPathLevels = splitOutputFile.length-splitProjMeta.length
        for j in (splitOutputFile.length-diffPathLevels)..(splitOutputFile.length-1)
          diffUp += splitOutputFile[j] + "/"
          diffArr << splitOutputFile[j]
        end
        for i in 0..diffPathLevels-1
          dir += "../"
        end
      elsif splitOutputFile.length < splitProjMeta.length
        diffPathLevelsDown = splitProjMeta.length-splitOutputFile.length
        puts "Warning: this case is not supported!"
        return nil
      else
        return bhash
      end
  
      pathNames = []
      directories = {}
    
      if File.dirname(outputFilePath).eql? File.dirname(bhash['BAKE_PROJECTDIR'][0])
        #files do not have to be adapted
      else
        bhash.each do |key, value|
          if key == 'BAKE_SOURCES' || key == 'BAKE_INCLUDES'
            value.each do |pathElm|
              if pathElm[0] == SLASH || pathElm[1] == COLON
                pathNames << pathElm #nothing to do - is already absolute
              elsif pathElm[0..diffUp.length-1].eql? diffUp
                pathNames << pathElm.split(/^#{diffUp}/)[-1]
              else 
                tmpElmArr = pathElm.split("/")
                cnt = 0
                dirLoc = ""
                if tmpElmArr[0] != ".." #string does not start with ".."
                  for j in (0..diffArr.length-1)
                    if diffArr[j] != tmpElmArr[j]
                      cnt = cnt + 1
                      dirLoc << "../"
                    end
                  end 
                  tmpElm = Util.truncateStr(diffUp,pathElm)
                  pathNames << (dirLoc + tmpElm)
                else #string starts with ".." -> don't have to cut
                  pathNames << (dir + pathElm)
                end
              end
            end
            directories.store(key, pathNames)
            pathNames = []
          else
            directories.store(key, value)
          end
        end
      end
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect if debugMode == true
        exit(1)
      end
      return directories
    end
      
  end
  
end