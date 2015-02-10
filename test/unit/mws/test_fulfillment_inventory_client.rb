require 'test_helper'
require 'mws/fulfillment_inventory/client'

class TestFulfillmentInventoryClient < MiniTest::Test
  def setup
    @client = MWS::FulfillmentInventory::Client.new
  end

  def test_list_inventory_supply_has_seller_skus
    @client.stub(:run, nil) do
      @client.list_inventory_supply(seller_skus: '1')
      assert @client.operation.key?('SellerSkus.member.1')
    end
  end
end
