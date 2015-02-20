require 'helper'
require 'mws/cart_information/client'

class TestMWSCartInformationClient < MiniTest::Test
  def setup
    @client = MWS::CartInformation::Client.new
  end

  def test_lists_carts
    operation = {
      'Action' => 'ListCarts',
      'DateRangeStart' => '1'
    }

    @client.stub(:run, nil) do
      @client.list_carts('1')
    end

    assert_equal operation, @client.operation
  end

  def test_lists_carts_by_next_token
    operation = {
      'Action' => 'ListCartsByNextToken',
      'NextToken' => '1'
    }

    @client.stub(:run, nil) do
      @client.list_carts_by_next_token('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_carts
    operation = {
      'Action' => 'GetCarts',
      'MarketplaceId' => '1',
      'CartIdList.CartId.1' => '2',
      'CartIdList.CartId.2' => '3'
    }

    @client.stub(:run, nil) do
      @client.get_carts('1', '2', '3')
    end

    assert_equal operation, @client.operation
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
end
