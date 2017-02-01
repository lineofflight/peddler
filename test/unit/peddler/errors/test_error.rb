require 'helper'
require 'peddler/errors/error'

class TestPeddlerErrorsError < MiniTest::Test
  def setup
    @error = Peddler::Errors::Error.new('message', 'cause')
  end

  def test_sets_message
    assert_equal 'message', @error.message
  end

  def test_sets_cause
    assert_equal 'cause', @error.cause
  end

  def test_defines_common_errors
    Peddler::Errors::CODES.each do |name|
      assert ::Peddler::Errors.const_defined?(name)
    end
  end
end
