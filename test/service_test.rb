require_relative 'test_helper'

class ServiceTest < MiniTest::Test
  def setup
    @klass = Class.new(Peddler::Service)
    @service = @klass.new('US', 'key', 'secret', 'seller_id')
  end

  def test_configures_path
    @klass.path('Foo')
    assert @service.endpoint.match(/Foo$/)
  end

  def test_has_user_agent
    refute @service.connection.data[:headers].empty?
  end

  def test_gets_marketplace_ids
    refute_equal @service.marketplace_id('US'), @service.marketplace_id('GB')
  end

  def test_inherits_parent_params
    assert_equal Peddler::Service.params, @klass.params
  end

  def test_inherits_parent_path
    @klass.path 'foo'
    assert_equal @klass.path, Class.new(@klass).path
  end

  def test_defines_constants_on_service
    refute_nil @klass.const_get(:HOSTS)
  end
end
