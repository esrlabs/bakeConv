# ConfigFileTest (UnitTest)
# Author: Frauke Blossey
# 23.04.2015

require 'minitest/autorun'
require 'FileUtils'

class ConfigFileTest < MiniTest::Unit::TestCase
  
  @@workingdir =  File.expand_path("../../bin/bakeConv", File.dirname(__FILE__))
  @@configFileDir = File.expand_path("../WorkingFiles/tools/Converter.config", File.dirname(__FILE__))
  @@configFileTestDir = File.expand_path("../ConfigFileTest", File.dirname(__FILE__))

  
  def test_ConfigFile_success
    res = `ruby #{@@workingdir} -f #{@@configFileDir} --mock`
    assert_equal true, $?.success?
  end
  
  def test_ConfigFile_notExisting
    res = `ruby #{@@workingdir} -f #{@@configFileTestDir}/ConverterTest.config --mock 2>&1`
    assert_includes res, 'No such file or directory'
  end
  
  def test_ConfigFile_empty
    res = `ruby #{@@workingdir} -f #{@@configFileTestDir}/ConverterEmpty.config --mock 2>&1`
    assert_includes res, 'empty'
  end
  
  def test_ConfigFile_mappingKW_missing
    res = `ruby #{@@workingdir} -f #{@@configFileTestDir}/ConverterMappingMissing.config --mock 2>&1`
    assert_includes res, 'Mapping keyword in front of line'
  end

  def test_ConfigFile_endLabel_missing
    res = `ruby #{@@workingdir} -f #{@@configFileTestDir}/ConverterEndLabelMissing.config --mock 2>&1`
    assert_includes res, 'end label } from Mapping'
  end
  
  def test_ConfigFile_paramter_missing
    res = `ruby #{@@workingdir} -f #{@@configFileTestDir}/ConverterParMissing.config --mock 2>&1`
    assert_includes res, 'parameter from Mapping in line'
  end
  
  def test_ConfigFile_noSources
    res = `ruby #{@@workingdir} -f #{@@configFileTestDir}/ConverterVarIsEmpty.config -p eepromManager_noSources --mock 2>&1`
    b_equal = FileUtils.compare_file("#{@@configFileTestDir}/CMakeLists.txt","#{@@configFileTestDir}/CMake_ref1.txt")
    assert_equal true, b_equal
  end
  
  def test_ConfigFile_noSources
    res = `ruby #{@@workingdir} -f #{@@configFileTestDir}/ConverterVarIsEmpty.config -p eepromManager_emptyVar --mock 2>&1`
    b_equal = FileUtils.compare_file("#{@@configFileTestDir}/CMakeListsUnittest.txt","#{@@configFileTestDir}/CMake_ref2.txt")
    assert_equal true, b_equal
  end
  
  def test_ConfigFile_comments
    res = `ruby #{@@workingdir} -f #{@@configFileTestDir}/ConverterComments.config --mock 2>&1`
    b_equal = FileUtils.compare_file("#{@@configFileTestDir}/ComTestCMakeLists.txt","#{@@configFileTestDir}/CMakeComTest_ref.txt")
    assert_equal true, b_equal
    b_exists = File.exists?("#{@@configFileTestDir}/ComTestCMakeListsUnittest.txt")
    assert_equal false, b_exists
  end
  
end