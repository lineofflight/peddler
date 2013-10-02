require 'helper'
require 'peddler/request/parameters'

class PeddlerRequestParametersTest < MiniTest::Test
  def setup
    @parameters = Peddler::Request::Parameters.new(:do_it)
  end

  def test_has_an_action_key
    assert_equal 'DoIt', @parameters.fetch('Action')
  end

  def test_formats_timestamps
    ts = Minitest::Mock.new
    ts.expect(:iso8601, 'formatted')
    @parameters.store('a timestamp', ts)
    assert_equal 'formatted', @parameters.timestamp!.fetch('a timestamp')
  end

  def test_formats_structured_lists
    @parameters.store(:order_status, 'foo')
    assert_equal 'foo', @parameters.format_structured_lists!.fetch('OrderStatus.Status.1')
  end

  def test_camelizes_keys
    @parameters.store(:underscored_key, 'baz')
    refute @parameters.camelize_keys!.has_key?(:underscored_key)
    assert @parameters.has_key?('UnderscoredKey')
  end

  def test_updates_delegated_hash
    assert_kind_of Peddler::Request::Parameters, @parameters.update(key: 'value')
    assert_equal 'value', @parameters.fetch(:key)
  end
end
