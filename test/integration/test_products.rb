require 'helper'
require 'mws/products'

class TestProducts < IntegrationTest
  def test_lists_matching_products
    clients.each do |client|
      res = client.list_matching_products('architecture')
      refute_empty res.parse
    end
  end

  def test_gets_matching_product
    clients.each do |client|
      res = client.get_matching_product('1780935374')
      refute_empty res.parse
    end
  end

  def test_gets_matching_product_for_id
    clients.each do |client|
      res = client.get_matching_product_for_id('ISBN', '9781780935379')
      refute_empty res.parse
    end
  end

  def test_gets_competitive_pricing_for_asin
    clients.each do |client|
      res = client.get_competitive_pricing_for_asin('1780935374')
      refute_empty res.parse
    end
  end

  def test_gets_lowest_offer_listings_for_asin
    clients.each do |client|
      res = client.get_lowest_offer_listings_for_asin('1780935374')
      refute_empty res.parse
    end
  end

  def test_gets_lowest_priced_offers_for_asin
    clients.each do |client|
      res = client.get_lowest_priced_offers_for_asin('1780935374', 'New')
      refute_empty res.parse
    end
  end

  def test_gets_product_categories_for_asin
    clients.each do |client|
      res = client.get_product_categories_for_asin('1780935374')
      refute_empty res.parse
    end
  end

  def test_gets_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end
end
