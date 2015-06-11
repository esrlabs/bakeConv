# TemplateFileTest (UnitTest)
# Author: Frauke Blossey
# 28.04.2015

require 'minitest/autorun'

class TemplateFileTest < MiniTest::Unit::TestCase
  
  @@workingdir =  File.expand_path("../../bin/bakeConv", File.dirname(__FILE__))
  @@templateFileTestDir = File.expand_path("../TemplateFileTest", File.dirname(__FILE__))
  
  def test_TemplateFile_notExisting
    res = `ruby #{@@workingdir} -f #{@@templateFileTestDir}/ConverterForNotExistTmp.config --mock 2>&1`
    assert_includes res, 'No such file or directory'     
  end
  
  def test_TemplateFile_empty
    res = `ruby #{@@workingdir} -f #{@@templateFileTestDir}/ConverterForEmptyTmp.config --mock 2>&1`
    assert_includes res, 'empty'
  end
  
  def test_TemplateFile_inclTmpEmpty
    res = `ruby #{@@workingdir} -f #{@@templateFileTestDir}/ConverterForEmptyTmpIncl.config --mock 2>&1`
    assert_includes res, 'empty'
  end
  
  def test_TemplateFile_inclTmp_notExisting
    res = `ruby #{@@workingdir} -f #{@@templateFileTestDir}/ConverterForNotExistTmpIncl.config --mock 2>&1`
    assert_includes res, 'not exist'
  end
  
#  ToDo: circular template dependencies
  
end