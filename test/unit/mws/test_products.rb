require 'helper'
require 'mws/products'

class MWSProductsTest < MiniTest::Test
  def test_operation_includes_marketplace_id
    client = MWS::Products.new
    assert client.operation('Foo').has_key?('MarketplaceId')
  end
end
