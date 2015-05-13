# ConfigFileTest (UnitTest)
# Author: Frauke Blossey
# 23.04.2015

require 'minitest/autorun'

class ConfigFileTest < MiniTest::Unit::TestCase
  
  def test_ConfigFile_success
    res = `ruby bakeConverter.rb -f ./test/WorkingFiles/tools/Converter.config --mock`
    assert_equal true, $?.success?
  end
  
  def test_ConfigFile_notExisting
    res = `ruby bakeConverter.rb -f ./test/ConfigFileTest/ConverterTest.config --mock 2>&1`
    assert_includes res, 'No such file or directory'
  end
  
  def test_ConfigFile_empty
    res = `ruby bakeConverter.rb -f ./test/ConfigFileTest/ConverterEmpty.config --mock 2>&1`
    assert_includes res, 'empty'
  end
  
  def test_ConfigFile_mappingKW_missing
    res = `ruby bakeConverter.rb -f ./test/ConfigFileTest/ConverterMappingMissing.config --mock 2>&1`
    assert_includes res, 'Mapping keyword is missing'
  end

  def test_ConfigFile_endLabel_missing
    res = `ruby bakeConverter.rb -f ./test/ConfigFileTest/ConverterEndLabelMissing.config --mock 2>&1`
    assert_includes res, 'end label } is missing'
  end
  
  def test_ConfigFile_paramter_missing
    res = `ruby bakeConverter.rb -f ./test/ConfigFileTest/ConverterParMissing.config --mock 2>&1`
    assert_includes res, 'parameter is missing!'
  end
  
end