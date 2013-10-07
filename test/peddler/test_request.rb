require 'helper'
require 'peddler/request'

class PeddlerRequestTest < MiniTest::Test
  def setup
    @request = Peddler::Request.new(nil)
  end

  def test_has_next_token?
    response = MiniTest::Mock.new
    @request.last_response = response

    response.expect(:next_token, nil)
    assert_equal false, @request.has_next_token?
    response.expect(:next_token, '123')
    assert_equal true, @request.has_next_token?
  end
end
