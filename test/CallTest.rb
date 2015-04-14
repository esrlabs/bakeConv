require 'minitest/autorun'

class CallTest < MiniTest::Unit::TestCase

  def test_call_success
    status = system("ruby", "bakeConverter.rb", "-f", "C:\\_dev\\ForBakeConv\\Files\\Converter.config")
    #status = `ruby bakeConverter.rb -f C:\\_dev\\ForBakeConv\\Files\\Converter.config`
    assert_equal true, status
  end
  
  def test_call_configFile_missing
    res = `ruby bakeConverter.rb 2>&1`
    st = $?.success?
    assert_equal false, st
    assert_includes "config file missing", res
  end
  
#  def test_call_misspelled
#  
#  end

end