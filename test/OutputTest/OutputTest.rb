# OutputTest (UnitTest)
# Author: Frauke Blossey
# 29.04.2015

require 'minitest/autorun'

class OutputTest < MiniTest::Unit::TestCase

  def setup
    File.delete("./test/OutputTest/CMakeLists.txt") if File.exist?("./test/OutputTest/CMakeLists.txt")
    File.delete("./test/OutputTest/CMakeListsUnittest.txt") if File.exist?("./test/OutputTest/CMakeListsUnittest.txt")
  end
    
  def test_OutputTest_fileEmpty
    res = `ruby bakeConverter.rb -f ./test/OutputTest/ConverterForEmptyTmpl.config --mock 2>&1`
    assert_includes res, 'empty'
  end
  
  def test_OutputTest_fileNotExisting
    res = `ruby bakeConverter.rb -f ./test/OutputTest/ConverterForNotExistTmp.config --mock 2>&1`
    assert_includes res, 'No such file or directory'
  end
  
  def test_OutputTest_notReplaced
    res = `ruby bakeConverter.rb -f ./test/OutputTest/ConverterForNotReplacing.config.config --mock 2>&1`
    assert_includes res, 'wasn\'t replaced!' 
  end

end
