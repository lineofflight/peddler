require 'helper'
require 'mws/products/client'

class TestMWSProductsClient < MiniTest::Test
  def setup
    @client = MWS::Products::Client.new
  end

  def test_operation_includes_marketplace_id
    client = MWS::Products::Client.new
    assert client.operation_with_marketplace('Foo').has_key?('MarketplaceId')
  end

  def test_gets_service_status
    operation = {
      'Action' => 'GetServiceStatus'
    }

    @client.stub(:run, nil) do
      @client.get_service_status
    end

    assert_equal operation, @client.operation
  end

  # FIXME Fill in tests for operations
end
