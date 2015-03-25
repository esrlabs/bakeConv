def doMapping(hash, workingdir, bakeHashFromBake, idx, inputFile, outputFile)
  mainTmpFile = workingdir + hash['InputDir'] + "\\"+ inputFile
  mainTmpFileReplaced = workingdir + hash['InputDir'] + "\\"+ outputFile
  
  File.open(mainTmpFileReplaced, 'w') do |fout|  
    File.open(mainTmpFile) do |f|
      File.readlines(f).each do |line|
        line.gsub!(/\$\$\(BAKE_NAME\)/, bakeHashFromBake['BAKE_NAME'][0].to_s)

        sourceResult = line.scan(/(.*)\$\$\(BAKE_SRC\)(.*)/)
        headerResult = line.scan(/(.*)\$\$\(BAKE_HEADER\)(.*)/)
        
        incldFileFound = false
        
        hash.keys.each do |k|  # search and replace other template files
          if line.match(k) && line.include?("BAKE_INCLD_TEMP_")
            searchFor = "\$\$\(" + k + ")"
            line.gsub!(searchFor, hash[k])
            incldFileFound = true
            inputFile = hash[k]
          end
        end
        
        if sourceResult.length > 0
          prefix = sourceResult[0][0]
          postfix = sourceResult[0][1]
          bakeHashFromBake['BAKE_SRC'].each do |src|
              fout.write(prefix + " " + src + " " + postfix + "\n") if prefix != ""
              fout.write(prefix + src + postfix + "\n") if prefix == ""
          end
        elsif headerResult.length > 0
          prefix = headerResult[0][0]
          postfix = headerResult[0][1]
          bakeHashFromBake['BAKE_HEADER'].each do |hdr|
            fout.write(prefix + " " + hdr + " " + postfix + "\n") if prefix != ""
            fout.write(prefix + hdr + postfix + "\n") if prefix == ""
          end
        elsif incldFileFound
          fileTmp = outputFile.split(".txt")
          fileTmp[0].gsub!(/#{idx-1}$/,idx.to_s) if idx > 1
          outputFile = fileTmp[0] + "_" + idx.to_s + ".txt" if idx == 1
          outputFile = fileTmp[0] + ".txt" if idx > 1
          idx += 1
          fout.write(line)
          doMapping(hash, workingdir, bakeHashFromBake, idx, inputFile, outputFile)
        else
          fout.write(line)
        end
      end
    end
  end
end


# main
# 
=begin
puts "Reading config..."
readConfig()
puts "Converting 10 projects..."
mappings.each do |mapping|
  puts "Convert 1 of 10: eepromManager (Debug)..."
  puts "Convert 2 of 10: bla (Debug)..."
  

end
  puts "Done"
=end

#module BConv
#
 # mappings.each do |mapping|
 #   puts "Call bake..."
 #   bake = Bake.new(...)
 #   bake.run();
 #   mapping = mapping << bake.getHash
 #   
  #  read
  
  #end

#end

