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
end
