require 'helper'
require 'peddler/headers'

class TestPeddlerHeaders < MiniTest::Test
  include ::Peddler::Headers

  attr_reader :headers

  def setup
    @headers = {
      'x-mws-quota-max' => '200.0',
      'x-mws-quota-remaining' => '200.0',
      'x-mws-quota-resetsOn' => '2017-01-30T00:03:00.000Z',
      'x-mws-request-id' => '123',
      'x-mws-timestamp' => '2017-01-29T23:55:25.356Z',
      'x-mws-response-context' => 'foo'
    }
  end

  def test_quota
    assert quota
    assert_kind_of Integer, quota.max
    assert_kind_of Integer, quota.remaining
    assert_kind_of Time, quota.resets_on
  end

  def test_request_id
    assert request_id
  end

  def test_timestamp
    assert_kind_of Time, timestamp
  end

  def test_response_context
    assert response_context
  end

  def test_handles_no_quota
    @headers = {}
    assert_nil quota
  end
end
