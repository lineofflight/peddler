require 'helper'
require 'mws/products/client'

class TestMWSProductsClient < MiniTest::Test
  def setup
    @client = MWS::Products::Client.new
    @client.primary_marketplace_id = '123'
  end

  def test_lists_matching_products
    operation = {
      'Action' => 'ListMatchingProducts',
      'MarketplaceId' => '123',
      'Query' => 'foo'
    }

    @client.stub(:run, nil) do
      @client.list_matching_products('foo')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_matching_product_for_id
    operation = {
      'Action' => 'GetMatchingProductForId',
      'MarketplaceId' => '123',
      'IdType' => 'foo',
      'IdList.Id.1' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_matching_product_for_id('foo', '1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_matching_product
    operation = {
      'Action' => 'GetMatchingProduct',
      'MarketplaceId' => '123',
      'ASINList.ASIN.1' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_matching_product('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_competitive_pricing_for_sku
    operation = {
      'Action' => 'GetCompetitivePricingForSKU',
      'MarketplaceId' => '123',
      'SellerSKUList.SellerSKU.1' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_competitive_pricing_for_sku('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_competitive_pricing_for_asin
    operation = {
      'Action' => 'GetCompetitivePricingForASIN',
      'MarketplaceId' => '123',
      'ASINList.ASIN.1' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_competitive_pricing_for_asin('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_lowest_offer_listings_for_sku
    operation = {
      'Action' => 'GetLowestOfferListingsForSKU',
      'MarketplaceId' => '123',
      'SellerSKUList.SellerSKU.1' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_lowest_offer_listings_for_sku('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_lowest_offer_listings_for_asin
    operation = {
      'Action' => 'GetLowestOfferListingsForASIN',
      'MarketplaceId' => '123',
      'ASINList.ASIN.1' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_lowest_offer_listings_for_asin('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_my_price_for_sku
    operation = {
      'Action' => 'GetMyPriceForSKU',
      'MarketplaceId' => '123',
      'SellerSKUList.SellerSKU.1' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_my_price_for_sku('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_my_price_for_asin
    operation = {
      'Action' => 'GetMyPriceForASIN',
      'MarketplaceId' => '123',
      'ASINList.ASIN.1' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_my_price_for_asin('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_product_categories_for_sku
    operation = {
      'Action' => 'GetProductCategoriesForSKU',
      'MarketplaceId' => '123',
      'SellerSKU' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_product_categories_for_sku('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_product_categories_for_asin
    operation = {
      'Action' => 'GetProductCategoriesForASIN',
      'MarketplaceId' => '123',
      'ASIN' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_product_categories_for_asin('1')
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
