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
end
