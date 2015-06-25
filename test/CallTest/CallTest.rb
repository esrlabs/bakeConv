# CallTest (UnitTest)
# Author: Frauke Blossey
# 14.04.2015

require 'minitest/autorun'

class CallTest < MiniTest::Unit::TestCase

  @@workingdir =  File.expand_path("../../bin/bakeConv", File.dirname(__FILE__))
  @@configFileDir = File.expand_path("../WorkingFiles/tools/Converter.config", File.dirname(__FILE__))

  def test_call_success
    res = `ruby #{@@workingdir} -f #{@@configFileDir} --mock`
    assert_equal true, $?.success?
  end
  
  def test_call_configFile_missing
    res = `ruby #{@@workingdir} -f --mock 2>&1`
    assert_equal false, $?.success?
    assert_includes res, 'Config file is missing'
  end
  
  def test_call_misspelled
    res = `ruby #{@@workingdir} -fi #{@@configFileDir} --mock 2>&1`
    assert_equal false, $?.success?
  end
  
  def test_call_mock_misspelled
    res = `ruby #{@@workingdir} -f #{@@configFileDir} --moc 2>&1`
    assert_equal false, $?.success?
    assert_includes res, 'Error: don\'t know'
  end
  
  def test_call_proj_misspelled
    res = `ruby #{@@workingdir} -f #{@@configFileDir} --pojet eepromManager --mock 2>&1`
    assert_equal false, $?.success?
    assert_includes res, 'Error: don\'t know'
  end
  
  def test_call_argument_missing
   res = `ruby #{@@workingdir} #{@@configFileDir} --mock 2>&1`
   assert_equal false, $?.success?
   assert_includes res, 'Error: \'-f\' is missing!'
  end
  
  def test_call_proj_arg_missing
    res = `ruby #{@@workingdir} -f #{@@configFileDir} -p --mock 2>&1`
    assert_equal false, $?.success?
    assert_includes res, 'Error: project is missing!'
  end
  
  def test_call_too_less_args
    res = `ruby #{@@workingdir} --mock 2>&1`
    assert_includes res, 'Error: Too less arguments!'
  end
  
end