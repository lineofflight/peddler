require 'helper'
require 'mws/customer_information/client'

class TestMWSCustomerInformationClient < MiniTest::Test
  def setup
    @client = MWS::CustomerInformation::Client.new
  end

  def test_lists_customers
    operation = {
      'Action' => 'ListCustomers'
    }

    @client.stub(:run, nil) do
      @client.list_customers
    end

    assert_equal operation, @client.operation
  end

  def test_lists_customers_by_next_token
    operation = {
      'Action' => 'ListCustomersByNextToken',
      'NextToken' => '1'
    }

    @client.stub(:run, nil) do
      @client.list_customers_by_next_token('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_customers_for_customer_id
    operation = {
      'Action' => 'GetCustomersForCustomerId',
      'CustomerIdList.CustomerId.1' => '1',
      'CustomerIdList.CustomerId.2' => '2'
    }

    @client.stub(:run, nil) do
      @client.get_customers_for_customer_id('1', '2')
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
