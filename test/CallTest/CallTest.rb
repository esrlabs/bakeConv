# CallTest (UnitTest)
# Author: Frauke Blossey
# 14.04.2015

require 'minitest/autorun'

class CallTest < MiniTest::Unit::TestCase

  def test_call_success
    res = `ruby bakeConverter.rb -f ./test/WorkingFiles/tools/Converter.config --mock`
    assert_equal true, $?.success?
  end
  
  def test_call_configFile_missing
    res = `ruby bakeConverter.rb -f --mock 2>&1`
    assert_equal false, $?.success?
    assert_includes res, 'config file is missing'
  end
  
  def test_call_misspelled
    res = `ruby bakeConverter.rb -fi ./test/WorkingFiles/tools/Converter.config --mock 2>&1`
    assert_equal false, $?.success?
  end
  
  def test_call_mock_misspelled
    res = `ruby bakeConverter.rb -f ./test/WorkingFiles/tools/Converter.config --moc 2>&1`
    assert_equal false, $?.success?
    assert_includes res, 'has to be called --mock'
  end
  
  def test_call_proj_misspelled
    res = `ruby bakeConverter.rb -f ./test/WorkingFiles/tools/Converter.config --pojet eepromManager --mock 2>&1`
    assert_equal false, $?.success?
    assert_includes res, 'has to be called --project or -p'
  end
  
  def test_call_argument_missing
   res = `ruby bakeConverter.rb ./test/WorkingFiles/tools/Converter.config --mock 2>&1`
   assert_equal false, $?.success?
   assert_includes res, 'command -f / --file is missing'
  end
  
  def test_call_too_many_args
    res = `ruby bakeConverter.rb -f ./test/WorkingFiles/tools/Converter.config -p eepromManager --mock blubb 2>&1`  
    assert_equal false, $?.success?     
    assert_includes res, 'Too many arguments'
  end
  
end