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
    assert_includes res, 'config file is missing'
  end
  
  def test_call_misspelled
    res = `ruby #{@@workingdir} -fi #{@@configFileDir} --mock 2>&1`
    assert_equal false, $?.success?
  end
  
  def test_call_mock_misspelled
    res = `ruby #{@@workingdir} -f #{@@configFileDir} --moc 2>&1`
    assert_equal false, $?.success?
    assert_includes res, 'has to be called --mock'
  end
  
  def test_call_proj_misspelled
    res = `ruby #{@@workingdir} -f #{@@configFileDir} --pojet eepromManager --mock 2>&1`
    assert_equal false, $?.success?
    assert_includes res, 'has to be called --project or -p'
  end
  
  def test_call_argument_missing
   res = `ruby #{@@workingdir} #{@@configFileDir} --mock 2>&1`
   assert_equal false, $?.success?
   assert_includes res, 'command -f / --file is missing'
  end
  
  def test_call_too_many_args
    res = `ruby #{@@workingdir} -f #{@@configFileDir} -p eepromManager --mock blubb 2>&1`  
    assert_equal false, $?.success?     
    assert_includes res, 'Too many arguments'
  end
  
end