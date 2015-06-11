# OutputTest (UnitTest)
# Author: Frauke Blossey
# 29.04.2015

require 'minitest/autorun'

class OutputTest < MiniTest::Unit::TestCase

  @@workingdir =  File.expand_path("../../bin/bakeConv", File.dirname(__FILE__))
  @@outputTestDir = File.expand_path("../OutputTest", File.dirname(__FILE__))

  def setup
    File.delete("#{@@outputTestDir}/CMakeLists.txt") if File.exist?("#{@@outputTestDir}/CMakeLists.txt")
    File.delete("#{@@outputTestDir}/CMakeListsUnittest.txt") if File.exist?("#{@@outputTestDir}/CMakeListsUnittest.txt")
  end
    
  def test_OutputTest_fileEmpty
    res = `ruby #{@@workingdir} -f #{@@outputTestDir}/ConverterForEmptyTmpl.config --mock 2>&1`
    assert_includes res, 'empty'
  end
  
  def test_OutputTest_fileNotExisting
    res = `ruby #{@@workingdir} -f #{@@outputTestDir}/ConverterForNotExistTmp.config --mock 2>&1`
    assert_includes res, 'No such file or directory'
  end
  
  def test_OutputTest_notReplaced
    res = `ruby #{@@workingdir} -f #{@@outputTestDir}/ConverterForNotReplacing.config --mock 2>&1`
    assert_includes res, 'wasn\'t replaced!' 
  end

end
