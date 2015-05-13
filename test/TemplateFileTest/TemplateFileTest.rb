# TemplateFileTest (UnitTest)
# Author: Frauke Blossey
# 28.04.2015

require 'minitest/autorun'

class TemplateFileTest < MiniTest::Unit::TestCase
  
  def test_TemplateFile_notExisting
    res = `ruby bakeConverter.rb -f ./test/TemplateFileTest/ConverterForNotExistTmp.config --mock 2>&1`
    assert_includes res, 'No such file or directory'     
  end
  
  def test_TemplateFile_empty
    res = `ruby bakeConverter.rb -f ./test/TemplateFileTest/ConverterForEmptyTmp.config --mock 2>&1`
    assert_includes res, 'empty'
  end
  
  def test_TemplateFile_inclTmpEmpty
    res = `ruby bakeConverter.rb -f ./test/TemplateFileTest/ConverterForEmptyTmpIncl.config --mock 2>&1`
    assert_includes res, 'empty'
  end
  
  def test_TemplateFile_inclTmp_notExisting
    res = `ruby bakeConverter.rb -f ./test/TemplateFileTest/ConverterForNotExistTmpIncl.config --mock 2>&1`
    assert_includes res, 'not exist'
  end
  
#  ToDo: circular template dependencies
  
end