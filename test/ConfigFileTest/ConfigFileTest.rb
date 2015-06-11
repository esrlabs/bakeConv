# ConfigFileTest (UnitTest)
# Author: Frauke Blossey
# 23.04.2015

require 'minitest/autorun'

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
  
end