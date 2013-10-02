require 'helper'
require 'peddler/client'

class PeddlerClientTest < MiniTest::Test
  def setup
    @klass = Class.new(Peddler::Client)
    @client = @klass.new('US', 'key', 'secret', 'merchant_id')
  end

  def test_configures_path
    @klass.path('Foo')
    assert @client.endpoint.match(/Foo$/)
  end

  def test_has_user_agent
    refute @client.connection.data[:headers].empty?
  end

  def test_returns_marketplace_ids
    refute_equal @client.marketplace_id('US'), @client.marketplace_id('GB')
  end

  def test_returns_default_marketplace_id
    assert_equal @client.marketplace_id, @client.marketplace_id('US')
  end

  def test_inherits_parent_params
    assert_equal Peddler::Client.params, @klass.params
  end

  def test_defines_constants_on_service
    refute_nil @klass.const_get(:HOSTS)
  end

  def test_has_a_key
    refute_nil @client.aws_access_key_id
  end

  def test_has_a_secret
    refute_nil @client.aws_secret_access_key
  end
end
